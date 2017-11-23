defmodule Kraken.Private do
  @doc """
  asset = base asset used to determine balance (default = ZUSD)
  """
  def trade_balance(config), do: post_private config, "TradeBalance"

  defp post_private(config, method, opts \\ %{}) do
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
