defmodule Kraken.Public do
  @doc """
  unixtime =  as unix timestamp
  rfc1123 = as RFC 1123 time format
  """
  def server_time, do: get_public "Time", %{}

  @doc """
  asset = comma delimited list of assets to get info on
  (optional.  default = all for given asset class)
  """  
  def asset_infos(opts), do: get_public "Assets", opts

  @doc """
  pair: comma delimited list of asset pairs to get info on (optional.  default = all)"
  """
  def asset_pairs(opts), do: get_public "AssetPairs", opts

  @doc """
  pair = comma delimited list of asset pairs to get info on
  """
  def ticker(opts), do: get_public "Ticker", opts

  @doc """
  pair = asset pair to get market depth for
  count = maximum number of asks/bids (optional)
  """
  def order_book(opts), do: get_public "Depth", opts

  @doc """
  pair = asset pair to get trade data for
  since = return trade data since given id (optional.  exclusive)
  """
  def trades(opts), do: get_public "Trades", opts

  @doc """
  pair = asset pair to get spread data for
  since = return spread data since given id (optional.  inclusive)
  """
  def spread(opts), do: get_public "Spread", opts

  defp get_public(method, opts) do
    config = Kraken.Config.create
    url = config.endpoint.base_uri <> "/" <> config.endpoint.api_version <> "/public/" <> method

    HTTPotion.get(url, query: opts)
  end
end
