defmodule Core.DomainLayer.Domains.Buyer.BuyerEntity do
  @moduledoc """
    Buyer Entity
  """

  use Joken.Config

  alias Core.DomainLayer.Domains.Buyer.BuyerEntity

  alias Core.DomainLayer.Common.ValueObjects.Id
  alias Core.DomainLayer.Common.ValueObjects.Created
  alias Core.DomainLayer.Common.ValueObjects.Email
  alias Core.DomainLayer.Common.ValueObjects.Password
  alias Core.DomainLayer.Common.ValueObjects.ConfirmingCode

  alias Core.DomainLayer.Common.Dtos.ImpossibleUpdateError
  alias Core.DomainLayer.Common.Dtos.ImpossibleCreateError
  alias Core.DomainLayer.Common.Dtos.EmailIsInvalidError
  alias Core.DomainLayer.Common.Dtos.TokenIsInvalidError
  alias Core.DomainLayer.Common.Dtos.PasswordIsInvalidError
  alias Core.DomainLayer.Common.Dtos.ConfirmingCodeIsNotTrueError
  alias Core.DomainLayer.Common.Dtos.PasswordIsNotTrueError
  alias Core.DomainLayer.Common.Dtos.ImpossibleAuthenticateError

  alias Core.DomainLayer.Common.Dtos.AuthenticatingData
  alias Core.DomainLayer.Common.Dtos.AuthorizatingData
  alias Core.DomainLayer.Common.Dtos.ChangingEmailData
  alias Core.DomainLayer.Common.Dtos.ChangingPasswordData
  alias Core.DomainLayer.Domains.Buyer.Dtos.CreatingData

  defstruct email: nil,
            password: nil,
            id: nil,
            created: nil

  @type t :: %BuyerEntity{
          email: Email.t(),
          password: Password.t(),
          id: Id.t(),
          created: Created.t()
        }

  @type ok :: {
          :ok,
          BuyerEntity.t()
        }

  @type error_creating :: {
          :error,
          ImpossibleCreateError.t()
          | ConfirmingCodeIsNotTrueError.t()
          | EmailIsInvalidError.t()
          | PasswordIsInvalidError.t()
        }

  @type ok_authenticating :: {
          :ok,
          binary()
        }

  @type error_authenticating :: {
          :error,
          ImpossibleAuthenticateError.t()
          | PasswordIsNotTrueError.t()
        }

  @type error_authorizating :: {
          :error,
          TokenIsInvalidError.t()
        }

  @type error_change_email :: {
          :error,
          ConfirmingCodeIsNotTrueError.t()
          | ImpossibleUpdateError.t()
          | EmailIsInvalidError.t()
          | TokenIsInvalidError.t()
        }

  @type error_change_password :: {
          :error,
          ImpossibleUpdateError.t()
          | TokenIsInvalidError.t()
          | PasswordIsInvalidError.t()
        }

  @spec create_confirming_code(binary()) :: ConfirmingCode.ok() | ConfirmingCode.error()
  def create_confirming_code(email) do
    ConfirmingCode.new(email)
  end

  @spec new(CreatingData.t(), ConfirmingCode.t()) :: ok() | error_creating()
  def new(%CreatingData{} = dto, %ConfirmingCode{} = value_code) do
    with {:ok, value_email} <- Email.new(dto.email),
         {:ok, value_password} <- Password.new(dto.password),
         true <- is_integer(dto.confirming_code),
         true <- value_code.code == dto.confirming_code do
      {
        :ok,
        %BuyerEntity{
          email: value_email,
          password: value_password,
          id: Id.new(),
          created: Created.new()
        }
      }
    else
      :false -> {:error, ConfirmingCodeIsNotTrueError.new()}
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  def new(_, _) do
    ImpossibleCreateError.new("Impossible create Buyer for invalid data")
  end

  @spec authenticate(BuyerEntity.t(), AuthenticatingData.t()) :: ok_authenticating() | error_authenticating()
  def authenticate(%BuyerEntity{} = entity, %AuthenticatingData{} = dto) do
    with true <- is_binary(dto.password),
         true <- Bcrypt.verify_pass(dto.password, entity.password.value) do
      exp = DateTime.utc_now() |> DateTime.to_unix() |> Kernel.+(900)
      signer = Joken.Signer.create("HS256", Application.get_env(:joken, :buyer_signer))

      case BuyerEntity.generate_and_sign(%{id: entity.id.value, exp: exp}, signer) do
        {:ok, token, _} ->
          {:ok, token}

        _ ->
          {
            :error,
            ImpossibleAuthenticateError.new("Error creating authentication token. Joken Error.")
          }
      end
    else
      false -> {:error, PasswordIsNotTrueError.new()}
    end
  end

  def authenticate(_, _) do
    ImpossibleAuthenticateError.new("Impossible authenticate Buyer for invalid data")
  end

  @spec authorizate(AuthorizatingData.t()) :: ok() | error_authorizating()
  def authorizate(%AuthorizatingData{} = dto) when is_binary(dto.token) do
    signer = Joken.Signer.create("HS256", Application.get_env(:joken, :buyer_signer))
    case BuyerEntity.verify_and_validate(dto.token, signer) do
      {:error, _} ->
        {:error, TokenIsInvalidError.new()}

      {:ok, claims} ->
        {:ok, %BuyerEntity{id: %Id{value: claims["id"]}}}
    end
  end

  def authorizate(_) do
    {:error, TokenIsInvalidError.new()}
  end

  @spec change_email(ConfirmingCode.t(), ChangingEmailData.t()) :: ok() | error_change_email()
  def change_email(%ConfirmingCode{} = value_code, %ChangingEmailData{} = dto) do
    with {:ok, user} <- authorizate(AuthorizatingData.new(dto.token)),
         true <- is_integer(dto.confirming_code),
         true <- dto.confirming_code == value_code.code,
         {:ok, value_email} <- Email.new(dto.email) do
      {
        :ok,
        %BuyerEntity{
          id: %Id{value: user.id.value},
          email: value_email
        }
      }
    else
      false -> {:error, ConfirmingCodeIsNotTrueError.new()}
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  def change_email(_, _) do
    {:error, ImpossibleUpdateError.new("Impossible change email for invalid data")}
  end

  @spec change_password(ChangingPasswordData.t()) :: ok() | error_change_password()
  def change_password(%ChangingPasswordData{} = dto) do
    with {:ok, user} <- authorizate(AuthorizatingData.new(dto.token)),
         {:ok, value_password} <- Password.new(dto.password) do
      {
        :ok,
        %BuyerEntity{
          id: %Id{value: user.id.value},
          password: value_password
        }
      }
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  def change_password(_) do
    {:error, ImpossibleUpdateError.new("Impossible change password for invalid data")}
  end
end
