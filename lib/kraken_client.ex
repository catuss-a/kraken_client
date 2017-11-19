defmodule KrakenClient do
  @moduledoc """
  Documentation for KrakenClient.
  """

  use HTTPotion.Base

  @base_uri "https://api.kraken.com"
  @api_version "0"

  def base_uri, do: @base_uri

  @doc """
  unixtime =  as unix timestamp
  rfc1123 = as RFC 1123 time format
  """
  def server_time, do: get_public "Time"

  @doc """
  asset = comma delimited list of assets to get info on
  (optional.  default = all for given asset class)
  """  
  def asset_infos(asset), do: get_public "Assets", %{asset: asset}

  @doc """
  pair: comma delimited list of asset pairs to get info on (optional.  default = all)"
  """
  def asset_pairs(pairs), do: get_public "AssetPairs", %{pair: pairs}

  @doc """
  pair = comma delimited list of asset pairs to get info on
  """
  def ticker(pairs), do: get_public "Ticker", %{pair: pairs}

  @doc """
  pair = asset pair to get market depth for
  count = maximum number of asks/bids (optional)
  """
  def order_book(pair), do: get_public "Depth", %{pair: pair}
  def order_book(pair, count), do: get_public "Depth", %{pair: pair, count: count}

  @doc """
  pair = asset pair to get trade data for
  since = return trade data since given id (optional.  exclusive)
  """
  def trades(pair), do: get_public "Trades", %{pair: pair}
  def trades(pair, since), do: get_public "Trades", %{pair: pair, since: since}

  @doc """
  pair = asset pair to get spread data for
  since = return spread data since given id (optional.  inclusive)
  """
  def spread(pair), do: get_public "Spread", %{pair: pair}
  def spread(pair, since), do: get_public "Spread", %{pair: pair, since: since}

  defp get_public(method, opts \\ nil) do
    url = @base_uri <> "/" <> @api_version <> "/public/" <> method
    HTTPotion.get(url, query: opts)
  end
end
