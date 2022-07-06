defmodule Core.DomainLayer.JWTEntity do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Token

  alias Core.DomainLayer.JWTEntity

  defstruct token: nil, refresh_token: nil

  @type t :: %JWTEntity{token: Token.t(), refresh_token: Token.t()}

  @type ok :: {:ok, JWTEntity.t()}

  @spec new(binary(), binary(), binary(), binary(), binary()) :: ok() | Token.error()
  def new(email, password, id, secret, secret_exchanging) do
    with {:ok, value_token} <- Token.new(email, password, id, secret, 900),
         {:ok, value_refresh_token} <- Token.new(email, password, id, secret_exchanging, 87000) do
      {
        :ok,
        %JWTEntity{
          token: value_token,
          refresh_token: value_refresh_token
        }
      }
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  @spec parse(binary(), binary()) :: Token.claims() | Token.error_parsing()
  def parse(token, secret) do
    Token.parse(token, secret)
  end

  @spec refresh(binary(), binary(), binary()) :: ok() | Token.error() | Token.error_parsing()
  def refresh(token, secret, secret_exchanging) do
    with {:ok, claims} <- Token.parse(token, secret_exchanging),
         {:ok, value_token} <- Token.new(claims[:email], claims[:password], claims[:id], secret, 900),
         {:ok, value_refresh_token} <-
           Token.new(claims[:email], claims[:password], claims[:id], secret_exchanging, 87000) do
      {
        :ok,
        %JWTEntity{
          token: value_token,
          refresh_token: value_refresh_token
        }
      }
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end
end
