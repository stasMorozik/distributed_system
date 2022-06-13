defmodule Core.CoreDomains.Domains.Token do
  use Joken.Config

  alias Core.CoreDomains.Domains.Token

  alias Core.CoreDomains.Domains.Password

  alias Core.CoreDomains.Domains.Password.ValueObjects.Confirmed

  alias Core.CoreDomains.Domains.Password.Dtos.HaveToConfirmError
  alias Core.CoreDomains.Domains.Token.Dtos.TokenIsInvalidError

  alias Core.CoreDomains.Common.ValueObjects.Id
  alias Core.CoreDomains.Common.Dtos.ImpossibleCreateError
  alias Core.CoreDomains.Common.Dtos.IdIsInvalidError

  @type ok ::
  {
    :ok,
    binary
  }

  @type error ::
  {
    :error,
    IdIsInvalidError.t()      |
    ImpossibleCreateError.t() |
    HaveToConfirmError.t()    |
    TokenIsInvalidError.t()
  }

  def create(%Password{
    confirmed: %Confirmed{value: true},
    email: _,
    id: %Id{value: id},
    password: _,
    created: _
  }, secret) when is_binary(id) and is_binary(secret) do
    now = DateTime.utc_now |> DateTime.to_unix()
    signer = Joken.Signer.create("HS256", secret)
    case Token.generate_and_sign(%{id: id, exp: now + 900}, signer) do
      {:erro, _, _} -> {:error, ImpossibleCreateError.new("Error Joken")}
      {:ok, token, _} -> {:ok, token}
    end
  end

  def create(%Password{
    confirmed: %Confirmed{value: false},
    email: _,
    id: %Id{value: id},
    password: _,
    created: _
  }, secret) when is_binary(id) and is_binary(secret) do
    {:error, HaveToConfirmError.new()}
  end

  def create(%Password{
    confirmed: _,
    email: _,
    id: _,
    password: _,
    created: _
  }, secret) when is_binary(secret) do
    {:error, IdIsInvalidError.new()}
  end

  def create(_, _) do
    {:error, ImpossibleCreateError.new("Data for creating token is invalid")}
  end

  def verify_token(token, signer) when is_binary(token) and is_binary(signer) do
    signer = Joken.Signer.create("HS256", signer)
    case Token.verify_and_validate(token, signer) do
      {:error, _} -> {:error, TokenIsInvalidError.new()}
      {:ok, claims} -> {:ok, claims["id"]}
    end
  end

  def verify_token(_, _) do
    {:error, TokenIsInvalidError.new()}
  end
end
