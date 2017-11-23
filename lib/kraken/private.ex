defmodule Kraken.Private do
  @doc """
  asset = base asset used to determine balance (default = ZUSD)
  """
  def trade_balance(config, opts \\ %{}), do: post_private config, "TradeBalance", opts

  @doc """
  trades = whether or not to include trades in output (optional.  default = false)
  userref = restrict results to given user reference id (optional)
  """
  def open_orders(config, opts \\ %{}), do: post_private config, "OpenOrders", opts

  @doc """
  trades = whether or not to include trades in output (optional.  default = false)
  userref = restrict results to given user reference id (optional)
  start = starting unix timestamp or order tx id of results (optional.  exclusive)
  end = ending unix timestamp or order tx id of results (optional.  inclusive)
  ofs = result offset
  closetime = which time to use (optional)
      open
      close
      both (default)
  """
  def closed_orders(config, opts \\ %{}), do: post_private config, "ClosedOrders", opts

  @doc """
  trades = whether or not to include trades in output (optional.  default = false)
  userref = restrict results to given user reference id (optional)
  txid = comma delimited list of transaction ids to query info about (20 maximum)
  """
  def query_orders(config, opts \\ %{}), do: post_private config, "QueryOrders", opts

  @doc """
  type = type of trade (optional)
      all = all types (default)
      any position = any position (open or closed)
      closed position = positions that have been closed
      closing position = any trade closing all or part of a position
      no position = non-positional trades
  trades = whether or not to include trades related to position in output (optional.  default = false)
  start = starting unix timestamp or trade tx id of results (optional.  exclusive)
  end = ending unix timestamp or trade tx id of results (optional.  inclusive)
  ofs = result offset
  """
  def trade_history(config, opts \\ %{}), do: post_private config, "TradesHistory", opts

  @doc """
  txid = comma delimited list of transaction ids to query info about (20 maximum)
  trades = whether or not to include trades related to position in output (optional.  default = false)
  """
  def query_trades(config, opts \\ %{}), do: post_private config, "QueryTrades", opts

  @doc """
  txid = comma delimited list of transaction ids to restrict output to
  docalcs = whether or not to include profit/loss calculations (optional.  default = false)
  """
  def open_positions(config, opts \\ %{}), do: post_private config, "OpenPositions", opts

  @doc """
  aclass = asset class (optional):
      currency (default)
  asset = comma delimited list of assets to restrict output to (optional.  default = all)
  type = type of ledger to retrieve (optional):
      all (default)
      deposit
      withdrawal
      trade
      margin
  start = starting unix timestamp or ledger id of results (optional.  exclusive)
  end = ending unix timestamp or ledger id of results (optional.  inclusive)
  ofs = result offset
  """
  def ledgers(config, opts \\ %{}), do: post_private config, "Ledgers", opts

  @doc """
  id = comma delimited list of ledger ids to query info about (20 maximum)
  """
  def query_ledgers(config, opts \\ %{}), do: post_private config, "QueryLedgers", opts

  @doc """
  pair = comma delimited list of asset pairs to get fee info on (optional)
  fee-info = whether or not to include fee info in results (optional)
  """
  def trade_volume(config, opts \\ %{}), do: post_private config, "TadeVolume", opts

  @doc """
  pair = asset pair
  type = type of order (buy/sell)
  ordertype = order type:
      market
      limit (price = limit price)
      stop-loss (price = stop loss price)
      take-profit (price = take profit price)
      stop-loss-profit (price = stop loss price, price2 = take profit price)
      stop-loss-profit-limit (price = stop loss price, price2 = take profit price)
      stop-loss-limit (price = stop loss trigger price, price2 = triggered limit price)
      take-profit-limit (price = take profit trigger price, price2 = triggered limit price)
      trailing-stop (price = trailing stop offset)
      trailing-stop-limit (price = trailing stop offset, price2 = triggered limit offset)
      stop-loss-and-limit (price = stop loss price, price2 = limit price)
      settle-position
  price = price (optional.  dependent upon ordertype)
  price2 = secondary price (optional.  dependent upon ordertype)
  volume = order volume in lots
  leverage = amount of leverage desired (optional.  default = none)
  oflags = comma delimited list of order flags (optional):
      viqc = volume in quote currency (not available for leveraged orders)
      fcib = prefer fee in base currency
      fciq = prefer fee in quote currency
      nompp = no market price protection
      post = post only order (available when ordertype = limit)
  starttm = scheduled start time (optional):
      0 = now (default)
      +<n> = schedule start time <n> seconds from now
      <n> = unix timestamp of start time
  expiretm = expiration time (optional):
      0 = no expiration (default)
      +<n> = expire <n> seconds from now
      <n> = unix timestamp of expiration time
  userref = user reference id.  32-bit signed number.  (optional)
  validate = validate inputs only.  do not submit order (optional)

  optional closing order to add to system when order gets filled:
      close[ordertype] = order type
      close[price] = price
      close[price2] = secondary price
  """
  def add_order(config, opts \\ %{}), do: post_private config, "AddOrder", opts

  @doc """
  txid = transaction id
  """
  def cancel_order(config, opts \\ %{}), do: post_private config, "CancelOrder", opts

  defp post_private(config, method, opts) do
    path_uri = "/" <> config.endpoint.api_version <> "/private/" <> method
    full_uri = config.endpoint.base_uri <> path_uri

    api_key = config.credentials.api_key 
    api_secret = config.credentials.api_secret |> Base.decode64 |> elem(1)

    opts = opts |> Map.put(:nonce, generate_nonce())
    encoded_body = URI.encode_query(opts)

    headers = [
      'API-Key': api_key,
      'API-Sign': generate_api_signature(api_secret, path_uri, encoded_body, opts[:nonce])
    ]

    HTTPotion.post(full_uri, [headers: headers, body: encoded_body])
  end

  defp generate_api_signature(api_secret, path_uri, data, nonce) do
    encoded_data = path_uri <> :crypto.hash(:sha256, nonce <> data)
    :crypto.hmac(:sha512, api_secret, encoded_data) |> Base.encode64
  end

  defp generate_nonce do
    to_string(:os.system_time)
  end
end
