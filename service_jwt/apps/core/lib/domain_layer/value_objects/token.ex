defmodule Core.DomainLayer.ValueObjects.Token do
  @moduledoc false

  use Joken.Config

  alias Core.DomainLayer.Dtos.EmailIsInvalidError
  alias Core.DomainLayer.Dtos.SecretIsInvalidError
  alias Core.DomainLayer.Dtos.ExpiredIsInvalidError
  alias Core.DomainLayer.Dtos.ImpossibleCreateError
  alias Core.DomainLayer.Dtos.JokenError

  alias Core.DomainLayer.Dtos.TokenIsInvalidError

  alias Core.DomainLayer.ValueObjects.Token

  defstruct value: nil

  @type t :: %Token{value: binary()}

  @type ok :: {:ok, Token.t()}

  @type error :: {
          :error,
          EmailIsInvalidError.t()
          | SecretIsInvalidError.t()
          | ExpiredIsInvalidError.t()
          | ImpossibleCreateError.t()
          | JokenError.t()
        }

  @type error_parsing :: {
          :error,
          TokenIsInvalidError.t()
          | SecretIsInvalidError.t()
        }

  @type claims :: {
          :ok,
          %{
            email: binary(),
            password: binary()
          }
        }

  @spec new(binary(), binary(), binary(), integer()) :: ok() | error()
  def new(email, password, secret, expired) when is_binary(password) do
    with {:ok, secret_v} <- validate_secret(secret),
         {:ok, expired_v} <- validate_exp(expired),
         {:ok, email_v} <- validate_email(email),
         expired_date <- DateTime.utc_now() |> DateTime.to_unix() |> Kernel.+(expired_v),
         signer <- Joken.Signer.create("HS256", secret_v),
         {:ok, token, _} <-
           Token.generate_and_sign(%{em: email_v, ps: password, exp: expired_date}, signer) do
      {
        :ok,
        %Token{value: token}
      }
    else
      {:error, dto} -> {:error, dto}
      _ -> {:error, JokenError.new()}
    end
  end

  def new(_, _, _, _) do
    {:error, ImpossibleCreateError.new()}
  end

  @spec parse(binary(), binary()) :: claims() | error_parsing()
  def parse(token, secret) when is_binary(token) do
    with {:ok, secret_v} <- validate_secret(secret),
         signer <- Joken.Signer.create("HS256", secret_v),
         {:ok, claims} <- Token.verify_and_validate(token, signer) do
      {
        :ok,
        %{
          email: claims["em"],
          password: claims["ps"]
        }
      }
    else
      {:error, %SecretIsInvalidError{message: m}} -> {:error, %SecretIsInvalidError{message: m}}
      {:error, _} -> {:error, TokenIsInvalidError.new()}
    end
  end

  def parse(_, _) do
    {:error, TokenIsInvalidError.new()}
  end

  defp validate_secret(s) when is_binary(s) do
    if String.length(s) > 10 && String.length(s) <= 20 do
      {:ok, s}
    else
      {:error, SecretIsInvalidError.new()}
    end
  end

  defp validate_secret(_) do
    {:error, SecretIsInvalidError.new()}
  end

  defp validate_exp(e) when is_integer(e) do
    if e >= 900 && e <= 87000 do
      {:ok, e}
    else
      {:error, ExpiredIsInvalidError.new()}
    end
  end

  defp validate_exp(_) do
    {:error, ExpiredIsInvalidError.new()}
  end

  defp validate_email(e) when is_binary(e) do
    if String.match?(e, ~r/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/) do
      {:ok, e}
    else
      {:error, EmailIsInvalidError.new()}
    end
  end

  defp validate_email(_) do
    {:error, EmailIsInvalidError.new()}
  end
end
