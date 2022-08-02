defmodule Core.DomainLayer.ValueObjects.Token do
  @moduledoc false

  use Joken.Config
  alias Core.DomainLayer.Errors.DomainError
  alias Core.DomainLayer.ValueObjects.Token

  defstruct value: nil

  @type t :: %Token{value: binary()}

  @type ok :: {:ok, Token.t()}

  @type error :: {
          :error,
          DomainError.t()
        }

  @type claims :: {
          :ok,
          %{
            email: binary(),
            password: binary(),
            id: binary()
          }
        }

  @spec new(binary(), binary(), binary(), binary(), integer()) :: ok() | error()
  def new(email, password, id, secret, expired) when is_binary(password) and is_binary(id) do
    with {:ok, secret_v} <- validate_secret(secret),
         {:ok, expired_v} <- validate_exp(expired),
         {:ok, email_v} <- validate_email(email),
         expired_date <- DateTime.utc_now() |> DateTime.to_unix() |> Kernel.+(expired_v),
         signer <- Joken.Signer.create("HS256", secret_v),
         {:ok, token, _} <-
           Token.generate_and_sign(%{em: email_v, ps: password, id: id, exp: expired_date}, signer) do
      {
        :ok,
        %Token{value: token}
      }
    else
      {:error, dto} -> {:error, dto}
      _ -> {:error, DomainError.new("Joken error")}
    end
  end

  def new(_, _, _, _) do
    {:error, DomainError.new("Invalid input data")}
  end

  @spec parse(binary(), binary()) :: claims() | error()
  def parse(token, secret) when is_binary(token) do
    with {:ok, secret_v} <- validate_secret(secret),
         signer <- Joken.Signer.create("HS256", secret_v),
         {:ok, claims} <- Token.verify_and_validate(token, signer) do
      {
        :ok,
        %{
          email: claims["em"],
          password: claims["ps"],
          id: claims["id"]
        }
      }
    else
      {:error, %DomainError{message: m}} -> {:error, %DomainError{message: m}}
      {:error, _} -> {:error, DomainError.new("Token is invalid")}
    end
  end

  def parse(_, _) do
    {:error, DomainError.new("Token is invalid")}
  end

  defp validate_secret(s) when is_binary(s) do
    if String.length(s) > 10 && String.length(s) <= 20 do
      {:ok, s}
    else
      {:error, DomainError.new("Secret is invalid")}
    end
  end

  defp validate_secret(_) do
    {:error, DomainError.new("Secret is invalid")}
  end

  defp validate_exp(e) when is_integer(e) do
    if e >= 900 && e <= 87000 do
      {:ok, e}
    else
      {:error, DomainError.new("Expired is invalid")}
    end
  end

  defp validate_exp(_) do
    {:error, DomainError.new("Expired is invalid")}
  end

  defp validate_email(e) when is_binary(e) do
    if String.match?(e, ~r/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/) do
      {:ok, e}
    else
      {:error, DomainError.new("Eamil is invalid")}
    end
  end

  defp validate_email(_) do
    {:error, DomainError.new("Eamil is invalid")}
  end
end
