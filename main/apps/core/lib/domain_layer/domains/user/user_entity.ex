defmodule Core.DomainLayer.Domains.User.UserEntity do
  @moduledoc """
    User Entity
  """

  use Joken.Config

  alias Core.DomainLayer.Domains.User.UserEntity

  alias Core.DomainLayer.Common.ValueObjects.Id
  alias Core.DomainLayer.Common.ValueObjects.Created
  alias Core.DomainLayer.Common.ValueObjects.Email
  alias Core.DomainLayer.Common.ValueObjects.Avatar
  alias Core.DomainLayer.Common.ValueObjects.Name
  alias Core.DomainLayer.Common.ValueObjects.Password
  alias Core.DomainLayer.Common.ValueObjects.PhoneNumber
  alias Core.DomainLayer.Common.ValueObjects.ConfirmingCode
  alias Core.DomainLayer.Domains.User.ValueObjects.Surname

  alias Core.DomainLayer.Common.Dtos.ImpossibleUpdateError
  alias Core.DomainLayer.Common.Dtos.ImpossibleCreateError
  alias Core.DomainLayer.Common.Dtos.ConfirmingCodeIsNotTrueError
  alias Core.DomainLayer.Common.Dtos.PasswordIsNotTrueError
  alias Core.DomainLayer.Common.Dtos.ImpossibleAuthenticateError
  alias Core.DomainLayer.Common.Dtos.EmailIsInvalidError
  alias Core.DomainLayer.Common.Dtos.NameIsInvalidError
  alias Core.DomainLayer.Common.Dtos.PhoneNumberIsInvalidError
  alias Core.DomainLayer.Common.Dtos.TokenIsInvalidError
  alias Core.DomainLayer.Common.Dtos.PasswordIsInvalidError
  alias Core.DomainLayer.Domains.User.Dtos.SurnameIsInvalidError

  alias Core.DomainLayer.Common.Dtos.AuthenticatingData
  alias Core.DomainLayer.Common.Dtos.AuthorizatingData
  alias Core.DomainLayer.Common.Dtos.ChangingEmailData
  alias Core.DomainLayer.Common.Dtos.ChangingPasswordData
  alias Core.DomainLayer.Domains.User.Dtos.ChangingPersonalityData
  alias Core.DomainLayer.Domains.User.Dtos.CreatingData

  defstruct name: nil,
            surname: nil,
            email: nil,
            phone: nil,
            password: nil,
            avatar: nil,
            id: nil,
            created: nil

  @type t :: %UserEntity{
          name: Name.t(),
          surname: Surname.t(),
          email: Email.t(),
          phone: PhoneNumber.t(),
          password: Password.t(),
          avatar: Avatar.t(),
          id: Id.t(),
          created: Created.t()
        }

  @type creating_map :: %{
          name: binary(),
          surname: binary(),
          email: binary(),
          phone: binary(),
          password: binary(),
          confirming_code: integer()
        }

  @type ok :: {
          :ok,
          UserEntity.t()
        }

  @type error_creating :: {
          :error,
          ImpossibleCreateError.t()
          | ConfirmingCodeIsNotTrueError.t()
          | EmailIsInvalidError.t()
          | NameIsInvalidError.t()
          | SurnameIsInvalidError.t()
          | PhoneNumberIsInvalidError.t()
          | NameIsInvalidError.t()
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

  @type error_change_personality :: {
          :error,
          ImpossibleUpdateError.t()
          | TokenIsInvalidError.t()
          | NameIsInvalidError.t()
          | SurnameIsInvalidError.t()
          | PhoneNumberIsInvalidError.t()
        }

  @spec create_confirming_code(binary()) :: ConfirmingCode.ok() | ConfirmingCode.error()
  def create_confirming_code(email) do
    ConfirmingCode.new(email)
  end

  @spec new(CreatingData.t(), ConfirmingCode.t()) :: ok() | error_creating()
  def new(%CreatingData{} = dto, %ConfirmingCode{} = value_code) do
    with {:ok, value_name} <- Name.new(dto.name),
         {:ok, value_surname} <- Surname.new(dto.surname),
         {:ok, value_email} <- Email.new(dto.email),
         {:ok, value_phone} <- PhoneNumber.new(dto.phone),
         {:ok, value_password} <- Password.new(dto.password),
         true <- is_integer(dto.confirming_code),
         true <- value_code.code == dto.confirming_code do
      {
        :ok,
        %UserEntity{
          name: value_name,
          surname: value_surname,
          email: value_email,
          phone: value_phone,
          password: value_password,
          avatar: nil,
          id: Id.new(),
          created: Created.new()
        }
      }
    else
      false -> {:error, ConfirmingCodeIsNotTrueError.new()}
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  def new(_, _) do
    ImpossibleCreateError.new("Impossible create User for invalid data")
  end

  @spec authenticate(UserEntity.t(), AuthenticatingData.t()) :: ok_authenticating() | error_authenticating()
  def authenticate(%UserEntity{} = entity, %AuthenticatingData{} = dto) do
    with true <- is_binary(dto.password),
         true <- Bcrypt.verify_pass(dto.password, entity.password.value) do
      exp = DateTime.utc_now() |> DateTime.to_unix() |> Kernel.+(900)
      signer = Joken.Signer.create("HS256", Application.get_env(:joken, :user_signer))

      case UserEntity.generate_and_sign(%{id: entity.id.value, exp: exp}, signer) do
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
    ImpossibleAuthenticateError.new("Impossible authenticate User for invalid data")
  end

  @spec authorizate(AuthorizatingData.t()) :: ok | error_authorizating()
  def authorizate(%AuthorizatingData{} = dto) when is_binary(dto.token) do
    signer = Joken.Signer.create("HS256", Application.get_env(:joken, :user_signer))
    case UserEntity.verify_and_validate(dto.token, signer) do
      {:error, _} ->
        {:error, TokenIsInvalidError.new()}

      {:ok, claims} ->
        {:ok, %UserEntity{id: %Id{value: claims["id"]}}}
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
        %UserEntity{
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
        %UserEntity{
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

  @spec change_personality_data(ChangingPersonalityData.t()) :: ok() | error_change_personality()
  def change_personality_data(%ChangingPersonalityData{} = dto)
      when is_binary(dto.phone) and is_binary(dto.name) and is_binary(dto.surname) do
    with {:ok, user} <- authorizate(AuthorizatingData.new(dto.token)),
         {:ok, value_phone} <- PhoneNumber.new(dto.phone),
         {:ok, value_name} <- Name.new(dto.name),
         {:ok, value_surname} <- Surname.new(dto.surname) do
      {
        :ok,
        %UserEntity{
          id: %Id{value: user.id.value},
          phone: value_phone,
          name: value_name,
          surname: value_surname
        }
      }
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  def change_personality_data(%ChangingPersonalityData{} = dto)
      when is_binary(dto.name) and is_binary(dto.surname) do
    with {:ok, user} <- authorizate(AuthorizatingData.new(dto.token)),
         {:ok, value_name} <- Name.new(dto.name),
         {:ok, value_surname} <- Surname.new(dto.surname) do
      {
        :ok,
        %UserEntity{
          id: %Id{value: user.id.value},
          name: value_name,
          surname: value_surname
        }
      }
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  def change_personality_data(%ChangingPersonalityData{} = dto)
      when is_binary(dto.phone) and is_binary(dto.surname) do
    with {:ok, user} <- authorizate(AuthorizatingData.new(dto.token)),
         {:ok, value_phone} <- PhoneNumber.new(dto.phone),
         {:ok, value_surname} <- Surname.new(dto.surname) do
      {
        :ok,
        %UserEntity{
          id: %Id{value: user.id.value},
          phone: value_phone,
          surname: value_surname
        }
      }
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  def change_personality_data(%ChangingPersonalityData{} = dto)
      when is_binary(dto.phone) and is_binary(dto.name) do
    with {:ok, user} <- authorizate(AuthorizatingData.new(dto.token)),
         {:ok, value_phone} <- PhoneNumber.new(dto.phone),
         {:ok, value_name} <- Name.new(dto.name) do
      {
        :ok,
        %UserEntity{
          id: %Id{value: user.id.value},
          phone: value_phone,
          name: value_name
        }
      }
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  def change_personality_data(%ChangingPersonalityData{} = dto)
      when is_binary(dto.phone) do
    with {:ok, user} <- authorizate(AuthorizatingData.new(dto.token)),
         {:ok, value_phone} <- PhoneNumber.new(dto.phone) do
      {
        :ok,
        %UserEntity{
          id: %Id{value: user.id.value},
          phone: value_phone
        }
      }
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  def change_personality_data(%ChangingPersonalityData{} = dto)
      when is_binary(dto.name) do
    with {:ok, user} <- authorizate(AuthorizatingData.new(dto.token)),
         {:ok, value_name} <- Name.new(dto.name) do
      {
        :ok,
        %UserEntity{
          id: %Id{value: user.id.value},
          name: value_name
        }
      }
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  def change_personality_data(%ChangingPersonalityData{} = dto)
      when is_binary(dto.surname) do
    with {:ok, user} <- authorizate(AuthorizatingData.new(dto.token)),
         {:ok, value_surname} <- Surname.new(dto.surname) do
      {
        :ok,
        %UserEntity{
          id: %Id{value: user.id.value},
          surname: value_surname
        }
      }
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end
end
