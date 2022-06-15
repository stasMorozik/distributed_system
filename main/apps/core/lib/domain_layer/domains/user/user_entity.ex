defmodule Core.DomainLayer.Domains.User.UserEntity do
  use Joken.Config

  alias Core.DomainLayer.Domains.User.UserEntity

  alias Core.DomainLayer.Common.ValueObjects.Id
  alias Core.DomainLayer.Common.ValueObjects.Created
  alias Core.DomainLayer.Common.ValueObjects.Email
  alias Core.DomainLayer.Common.ValueObjects.Avatar
  alias Core.DomainLayer.Common.ValueObjects.Name
  alias Core.DomainLayer.Common.ValueObjects.Password

  alias Core.DomainLayer.Domains.User.ValueObjects.Surname
  alias Core.DomainLayer.Common.ValueObjects.PhoneNumber

  alias Core.DomainLayer.Common.Dtos.ImpossibleUpdateError
  alias Core.DomainLayer.Common.Dtos.ImpossibleCreateError
  alias Core.DomainLayer.Common.Dtos.ConfirmingCodeIsInvalidError
  alias Core.DomainLayer.Common.Dtos.ConfirmingCodeIsNotTrueError
  alias Core.DomainLayer.Common.Dtos.PasswordIsInvalidError
  alias Core.DomainLayer.Common.Dtos.PasswordIsNotTrueError
  alias Core.DomainLayer.Common.Dtos.ImpossibleAuthenticateError
  alias Core.DomainLayer.Common.Dtos.TokenIsInvalidError
  alias Core.DomainLayer.Common.Dtos.ImpossibleUpdateError

  alias Core.DomainLayer.Common.ValueObjects.ConfirmingCode

  defstruct name: nil, surname: nil, email: nil, phone: nil, password: nil, avatar: nil, id: nil, created: nil

  @type t :: %UserEntity {
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
    ImpossibleCreateError.t()         |
    ConfirmingCodeIsInvalidError.t()  |
    ConfirmingCodeIsNotTrueError.t()
  } | PhoneNumber.error() | Name.error() | Surname.error() | Email.error() | Password.error()

  @type ok_authenticating :: {
    :ok,
    binary()
  }

  @type error_authenticating :: {
    :error,
    ImpossibleAuthenticateError.t() |
    PasswordIsInvalidError.t()      |
    PasswordIsNotTrueError.t()
  }

  @type error_authorizating :: {
    :error,
    TokenIsInvalidError.t()
  }

  @type error_change_email :: {
    :error,
    ConfirmingCodeIsInvalidError.t() |
    ConfirmingCodeIsNotTrueError.t() |
    ImpossibleUpdateError.t()
  } | Email.error() | error_authorizating()

  @type error_change_password :: {
    :error,
    ImpossibleUpdateError.t()
  } | Password.error() | error_authorizating()

  @type personality_data :: %{phone: any(), name: any(), surname: any(), token: binary()}

  @type error_change_personality_data :: {
    :error,
    ImpossibleUpdateError.t()
  }  | error_authorizating() | PhoneNumber.error() | Name.error() | Surname.error()

  @spec create_confirming_code(binary()) :: ConfirmingCode.ok() | ConfirmingCode.error()
  def create_confirming_code(email) do
    ConfirmingCode.new(email)
  end

  @spec new(creating_map(), ConfirmingCode.t()) :: ok() | error_creating()
  def new(
    %{
      name: name,
      surname: surname,
      email: email,
      phone: phone,
      password: password,
      confirming_code: confirming_code
    },
    %ConfirmingCode{code: code, email: _}
  ) do
    case Name.new(name) do
      {:error, error_dto} -> {:error, error_dto}
      {:ok , value_name} ->
        case Surname.new(surname) do
          {:error, error_dto} -> {:error, error_dto}
          {:ok , value_surname} ->
            case Email.new(email) do
              {:error, error_dto} -> {:error, error_dto}
              {:ok, value_email} ->
                case PhoneNumber.new(phone) do
                  {:error, error_dto} -> {:error, error_dto}
                  {:ok, value_phone} ->
                    case Password.new(password) do
                      {:error, error_dto} -> {:error, error_dto}
                      {:ok, value_password} ->
                        case is_integer(confirming_code) do
                          :false -> {:error, ConfirmingCodeIsInvalidError.new()}
                          :true ->
                            case confirming_code == code do
                              :false -> {:error, ConfirmingCodeIsNotTrueError.new()}
                              :true ->
                                {:ok, %UserEntity{
                                  name: value_name,
                                  surname: value_surname,
                                  email: value_email,
                                  phone: value_phone,
                                  password: value_password,
                                  avatar: nil,
                                  id: Id.new(),
                                  created: Created.new()
                                }}
                            end
                        end
                    end
                end
            end
        end
    end
  end

  def new(_, _) do
    ImpossibleCreateError.new("Impossible create User for invalid data")
  end

  @spec authenticate(UserEntity.t(), %{password: binary()}) :: ok_authenticating() | error_authenticating()
  def authenticate(
    %UserEntity {
      name: %Name{value: _},
      surname: %Surname{value: _},
      email: %Email{value: _},
      phone: %PhoneNumber{value: _},
      password: %Password{value: password},
      avatar: _,
      id: %Id{value: id},
      created: %Created{value: _}
    },
    %{password: maybe_own_password}
  ) do
    case is_binary(maybe_own_password) do
      :false -> {:error, PasswordIsInvalidError.new()}
      :true ->
        case Bcrypt.verify_pass(maybe_own_password, password) do
          :false -> {:error, PasswordIsNotTrueError.new()}
          :true ->
            now = DateTime.utc_now |> DateTime.to_unix()
            case UserEntity.generate_and_sign(%{id: id, exp: now + 900}, Joken.Signer.create("HS256", Application.get_env(:joken, :user_signer))) do
              {:error, _, _} -> {:error, ImpossibleAuthenticateError.new("Error creating authentication token. Joken Error.")}
              {:ok, token, _} -> {:ok, token}
            end
        end
    end
  end

  def authenticate(_, _) do
    ImpossibleAuthenticateError.new("Impossible authenticate User for invalid data")
  end

  @spec authorizate(%{token: binary()}) :: ok | error_authorizating()
  def authorizate(%{token: token}) do
    case is_binary(token) do
      :false -> {:error, TokenIsInvalidError.new()}
      :true ->
        case UserEntity.verify_and_validate(token, Application.get_env(:joken, :user_signer)) do
          {:error, _} -> {:error, TokenIsInvalidError.new()}
          {:ok, claims} -> {
            :ok,
            %UserEntity{
              id: %Id{value: claims["id"]}
            }
          }
        end
    end
  end

  def authorizate(_) do
    {:error, TokenIsInvalidError.new()}
  end

  @spec change_email(
    ConfirmingCode.t(),
    %{email: binary(), confirming_code: binary(), token: binary()}
  ) :: ok() | error_change_email()
  def change_email(
    %ConfirmingCode{code: code, email: _},
    %{email: new_email, confirming_code: confirming_code, token: token}
  ) do
    case authorizate(%{token: token}) do
      {:error, error_dto} -> {:error, error_dto}
      {:ok, user} ->
        case is_integer(confirming_code) do
          :false -> {:error, ConfirmingCodeIsInvalidError.new()}
          :true ->
            case confirming_code == code do
              :false -> {:error, ConfirmingCodeIsNotTrueError.new()}
              :true ->
                case Email.new(new_email) do
                  {:error, error_dto} -> {:error, error_dto}
                  {:ok, value_email} ->
                    %UserEntity {
                      id: %Id{value: user.id.value},
                      email: value_email
                    }
                end
            end
        end
    end
  end

  def change_email(_, _) do
    {:error, ImpossibleUpdateError.new("Impossible change email for invalid data")}
  end

  @spec change_password(%{password: binary(), token: binary()}) :: ok() | error_change_password()
  def change_password(%{password: password, token: token}) do
    case authorizate(%{token: token}) do
      {:error, error_dto} -> {:error, error_dto}
      {:ok, user} ->
        case Password.new(password) do
          {:error, error_dto} -> {:error, error_dto}
          {:ok, value_password} ->
            %UserEntity {
              id: %Id{value: user.id.value},
              password: value_password
            }
        end
    end
  end

  def change_password(_) do
    {:error, ImpossibleUpdateError.new("Impossible change password for invalid data")}
  end

  @spec change_personality_data(personality_data()) :: ok() | error_change_personality_data()
  def change_personality_data(%{phone: phone, name: name, surname: surname, token: token}) when
  is_binary(phone) and
  is_binary(name) and
  is_binary(surname) do
    case authorizate(%{token: token}) do
      {:error, error_dto} -> {:error, error_dto}
      {:ok, user} ->
        case PhoneNumber.new(phone) do
          {:error, error_dto} -> {:error, error_dto}
          {:ok, value_phone} ->
            case Name.new(name) do
              {:error, error_dto} -> {:error, error_dto}
              {:ok, value_name} ->
                case Surname.new(surname) do
                  {:error, error_dto} -> {:error, error_dto}
                  {:ok, value_surname} ->
                    {
                      :ok,
                      %UserEntity {
                        id: %Id{value: user.id.value},
                        phone: value_phone,
                        name: value_name,
                        surname: value_surname
                      }
                    }
                end
            end
        end
    end
  end

  def change_personality_data(%{phone: _, name: name, surname: surname, token: token}) when
  is_binary(name) and
  is_binary(surname) do
    case authorizate(%{token: token}) do
      {:error, error_dto} -> {:error, error_dto}
      {:ok, user} ->
        case Name.new(name) do
          {:error, error_dto} -> {:error, error_dto}
          {:ok, value_name} ->
            case Surname.new(surname) do
              {:error, error_dto} -> {:error, error_dto}
              {:ok, value_surname} ->
                {
                  :ok,
                  %UserEntity {
                    id: %Id{value: user.id.value},
                    name: value_name,
                    surname: value_surname
                  }
                }
            end
        end
    end
  end

  def change_personality_data(%{phone: phone, name: _, surname: surname, token: token}) when
  is_binary(phone) and
  is_binary(surname) do
    case authorizate(%{token: token}) do
      {:error, error_dto} -> {:error, error_dto}
      {:ok, user} ->
        case PhoneNumber.new(phone) do
          {:error, error_dto} -> {:error, error_dto}
          {:ok, value_phone} ->
            case Surname.new(surname) do
              {:error, error_dto} -> {:error, error_dto}
              {:ok, value_surname} ->
                {
                  :ok,
                  %UserEntity {
                    id: %Id{value: user.id.value},
                    phone: value_phone,
                    surname: value_surname
                  }
                }
            end
        end
    end
  end

  def change_personality_data(%{phone: phone, name: name, surname: _, token: token}) when
  is_binary(phone) and
  is_binary(name) do
    case authorizate(%{token: token}) do
      {:error, error_dto} -> {:error, error_dto}
      {:ok, user} ->
        case PhoneNumber.new(phone) do
          {:error, error_dto} -> {:error, error_dto}
          {:ok, value_phone} ->
            case Name.new(name) do
              {:error, error_dto} -> {:error, error_dto}
              {:ok, value_name} ->
                {
                  :ok,
                  %UserEntity {
                    id: %Id{value: user.id.value},
                    phone: value_phone,
                    name: value_name
                  }
                }
            end
        end
    end
  end

  def change_personality_data(%{phone: phone, name: _, surname: _, token: token}) when
  is_binary(phone) do
    case authorizate(%{token: token}) do
      {:error, error_dto} -> {:error, error_dto}
      {:ok, user} ->
        case PhoneNumber.new(phone) do
          {:error, error_dto} -> {:error, error_dto}
          {:ok, value_phone} ->
            {
              :ok,
              %UserEntity {
                id: %Id{value: user.id.value},
                phone: value_phone
              }
            }
        end
    end
  end

  def change_personality_data(%{phone: _, name: name, surname: _, token: token}) when
  is_binary(name) do
    case authorizate(%{token: token}) do
      {:error, error_dto} -> {:error, error_dto}
      {:ok, user} ->
        case Name.new(name) do
          {:error, error_dto} -> {:error, error_dto}
          {:ok, value_name} ->
            {
              :ok,
              %UserEntity {
                id: %Id{value: user.id.value},
                name: value_name
              }
            }
        end
    end
  end

  def change_personality_data(%{phone: _, name: _, surname: surname, token: token}) when
  is_binary(surname) do
    case authorizate(%{token: token}) do
      {:error, error_dto} -> {:error, error_dto}
      {:ok, user} ->
        case Surname.new(surname) do
          {:error, error_dto} -> {:error, error_dto}
          {:ok, value_surname} ->
            {
              :ok,
              %UserEntity {
                id: %Id{value: user.id.value},
                surname: value_surname
              }
            }
        end
    end
  end
end
