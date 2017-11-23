defmodule Kraken.Config do
  defstruct credentials: nil, endpoint: %{base_uri: "https://api.kraken.com", api_version: "0"}

  @typedoc """
  A couple of keys to access to the private Kraken API.
  """
  @type credentials :: %{api_key: binary, api_secret: binary}

  @typedoc """
  A couple containing the base url and version of the Kraken API endpoint.
  """
  @type endpoint :: %{base_uri: binary, api_version: binary}

  @typedoc """
  A structure containing a pair of keys and the Endpoint API.
  """
  @type t :: %__MODULE__{credentials: credentials, endpoint: endpoint}

  def create,                   do: %__MODULE__{}
  def create(creds),            do: %__MODULE__{credentials: creds}
  def create(creds, endpoint),  do: %__MODULE__{credentials: creds, endpoint: endpoint}
end
