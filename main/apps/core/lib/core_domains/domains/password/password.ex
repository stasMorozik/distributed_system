defmodule Core.CoreDomains.Domains.Password do
  alias Core.CoreDomains.Domains.Password

  alias Core.CoreDomains.Domains.Password.ValueObjects.Email
  alias Core.CoreDomains.Domains.Password.ValueObjects.ConfirmingCode
  alias Core.CoreDomains.Domains.Password.ValueObjects.Confirmed
  alias Core.CoreDomains.Domains.Password.ValueObjects.Password, as: ValuePassword
  alias Core.CoreDomains.Common.ValueObjects.Id
  alias Core.CoreDomains.Common.ValueObjects.Created

  alias Core.CoreDomains.Domains.Password.Dtos.EmailIsInvalidError
  alias Core.CoreDomains.Domains.Password.Dtos.PasswordIsInvalidError
  alias Core.CoreDomains.Domains.Password.Dtos.EmailPasswordAreInvalidError
  alias Core.CoreDomains.Domains.Password.Dtos.ConfirmingCodeIsInvalidError
  alias Core.CoreDomains.Domains.Password.Dtos.PasswordConfirmingCodeAreInvalidError
  alias Core.CoreDomains.Domains.Password.Dtos.ImpossibleConfirmError
  alias Core.CoreDomains.Domains.Password.Dtos.AlreadyConfirmedError
  alias Core.CoreDomains.Domains.Password.Dtos.PasswordIsNotTrueError
  alias Core.CoreDomains.Domains.Password.Dtos.ConfirmingCodeIsNotTrueError
  alias Core.CoreDomains.Domains.Password.Dtos.ImpossibleChangeError
  alias Core.CoreDomains.Domains.Password.Dtos.HaveToConfirmError
  alias Core.CoreDomains.Domains.Password.Dtos.ImpossibleChangeEmailError
  alias Core.CoreDomains.Domains.Password.Dtos.ImpossibleValidateError

  defstruct id: nil, password: nil,  email: nil, confirmed: nil, confirmed_code: nil, created: nil

  @type t :: %Password{
    confirmed: Confirmed.t(),
    confirmed_code: ConfirmingCode.t() | nil,
    email: Email.t(),
    id: Id.t(),
    password: ValuePassword.t(),
    created: Created.t()
  }

  @type ok ::
  {
    :ok,
    Password.t()
  }

  @type error ::
  {
    :error,
    EmailIsInvalidError                   |
    PasswordIsInvalidError                |
    EmailPasswordAreInvalidError          |
    ConfirmingCodeIsInvalidError          |
    ImpossibleConfirmError                |
    AlreadyConfirmedError                 |
    PasswordIsNotTrueError                |
    ConfirmingCodeIsNotTrueError          |
    ImpossibleChangeError                 |
    HaveToConfirmError                    |
    ImpossibleChangeEmailError            |
    ImpossibleValidateError               |
    PasswordConfirmingCodeAreInvalidError
  }

  @doc """
   Function creating password
  """
  @spec create(binary, binary) :: ok | error
  def create(email, password) when is_binary(email) and is_binary(password) do
    case Email.new(email) do
      {:error, dto} -> {:error, dto}
      {:ok, value_email} ->
        case ValuePassword.new(password) do
          {:error, dto} -> {:error, dto}
          {:ok, value_password} -> {
            :ok,
            %Password {
              id: Id.new(),
              password: value_password,
              email: value_email,
              confirmed: Confirmed.new(),
              confirmed_code: ConfirmingCode.new(),
              created: Created.new()
            }
          }
        end
    end
  end

  def create(email, _) when is_binary(email) do
    {:error, PasswordIsInvalidError.new()}
  end

  def create(_, password) when is_binary(password) do
    {:error, EmailIsInvalidError.new()}
  end

  def create(_, _) do
    {:error, EmailPasswordAreInvalidError.new()}
  end

  @doc """
   Function confirming password
   To confirm password must check it and check confirming code
  """
  @spec confirm(Password.t(), binary, integer) :: ok | error
  def confirm(%Password{
    confirmed: %Confirmed{value: :false},
    confirmed_code: %ConfirmingCode{value: own_code},
    email: email,
    id: id,
    password: %ValuePassword{value: own_password},
    created: created
  }, maybe_own_password, maybe_own_code) when is_binary(maybe_own_password) and is_integer(maybe_own_code) do
    case check_password(own_password, maybe_own_password) do
      :false -> {:error, PasswordIsNotTrueError.new()}
      :true ->
        case maybe_own_code == own_code do
          :false -> {:error, ConfirmingCodeIsNotTrueError.new()}
          :true -> {
            :ok,
            %Password{
              confirmed: %Confirmed{value: :true},
              confirmed_code: %ConfirmingCode{value: own_code},
              email: email,
              id: id,
              password: %ValuePassword{value: own_password},
              created: created
            }
          }
        end
    end
  end

  def confirm(%Password{
    confirmed: %Confirmed{value: :true},
    confirmed_code: _,
    email: _,
    id: _,
    password: _,
    created: _
  }, maybe_own_password, maybe_own_code) when is_binary(maybe_own_password) and is_integer(maybe_own_code) do
    {:error, AlreadyConfirmedError.new()}
  end

  def confirm(%Password{
    confirmed: %Confirmed{value: :true},
    confirmed_code: nil,
    email: _,
    id: _,
    password: _,
    created: _
  }, maybe_own_password, maybe_own_code) when is_binary(maybe_own_password) and is_integer(maybe_own_code) do
    {:error, AlreadyConfirmedError.new()}
  end

  def confirm(%Password{
    confirmed: _,
    confirmed_code: _,
    email: _,
    id: _,
    password: _,
    created: _
  }, maybe_own_password, _) when is_binary(maybe_own_password) do
    {:error, ConfirmingCodeIsInvalidError.new()}
  end

  def confirm(%Password{
    confirmed: _,
    confirmed_code: _,
    email: _,
    id: _,
    password: _,
    created: _
  }, _, maybe_own_code) when is_integer(maybe_own_code) do
    {:error, PasswordIsInvalidError.new()}
  end

  def confirm(%Password{
    confirmed: _,
    confirmed_code: _,
    email: _,
    id: _,
    password: _,
    created: _
  }, _, _) do
    {:error, PasswordConfirmingCodeAreInvalidError.new()}
  end

  def confirm(_, _, _) do
    {:error, ImpossibleConfirmError.new("Impossible confirm email for invalid data")}
  end

  @doc """
   Function changing password
   To change password must check it and confirm it
  """
  @spec change_password(Password.t(), binary, binary) :: ok | error
  def change_password(%Password{
    confirmed: %Confirmed{value: :true},
    confirmed_code: _,
    email: email,
    id: id,
    password: %ValuePassword{value: own_password},
    created: created
  }, maybe_own_password, new_password) when is_binary(maybe_own_password) and is_binary(new_password) do
    case check_password(own_password, maybe_own_password) do
      :false -> {:error, PasswordIsNotTrueError.new()}
      :true ->
        case ValuePassword.new(new_password) do
          {:error, dto} -> {:error, dto}
          {:ok, value_password} -> {
            :ok,
            %Password {
              id: id,
              password: value_password,
              email: email,
              confirmed: %Confirmed{value: :true},
              created: created
            }
          }
        end
    end
  end

  def change_password(%Password{
    confirmed: %Confirmed{value: :false},
    confirmed_code: _,
    email: _,
    id: _,
    password: _,
    created: _
  }, maybe_own_password, new_password) when is_binary(maybe_own_password) and is_binary(new_password) do
    {:error, HaveToConfirmError.new()}
  end

  def change_password(%Password{
    confirmed: _,
    confirmed_code: _,
    email: _,
    id: _,
    password: _,
    created: _
  }, _, _) do
    {:error, PasswordIsInvalidError.new()}
  end

  def change_password(_, _) do
    {:error, ImpossibleChangeError.new("Impossible change password for invalid data")}
  end

  @doc """
   Function changing email
   To change email must check password and confirm it
  """
  @spec change_email(Password.t(), binary, binary) :: ok | error
  def change_email(%Password{
    confirmed: %Confirmed{value: :true},
    confirmed_code: _,
    email: _,
    id: id,
    password: %ValuePassword{value: own_password},
    created: created
  }, maybe_own_password, new_email) when is_binary(maybe_own_password) and is_binary(new_email) do
    case check_password(own_password, maybe_own_password) do
      :false -> {:error, PasswordIsNotTrueError.new()}
      :true ->
        case Email.new(new_email) do
          {:error, dto} -> {:error, dto}
          {:ok, value_email} -> {
            :ok,
            %Password{
              confirmed: %Confirmed{value: :true},
              email: value_email,
              id: id,
              password: %ValuePassword{value: own_password},
              created: created
            }
          }
        end
    end
  end

  def change_email(%Password{
    confirmed: %Confirmed{value: :false},
    confirmed_code: _,
    email: _,
    id: _,
    password: _,
    created: _
  }, maybe_own_password, new_email) when is_binary(maybe_own_password) and is_binary(new_email) do
    {:error, HaveToConfirmError.new()}
  end

  def change_email(%Password{
    confirmed: _,
    confirmed_code: _,
    email: _,
    id: _,
    password: _,
    created: _
  }, maybe_own_password, _) when is_binary(maybe_own_password) do
    {:error, EmailIsInvalidError.new()}
  end

  def change_email(%Password{
    confirmed: _,
    confirmed_code: _,
    email: _,
    id: _,
    password: _,
    created: _
  }, _, new_email) when is_binary(new_email) do
    {:error, PasswordIsInvalidError.new()}
  end

  def change_email(%Password{
    confirmed: _,
    confirmed_code: _,
    email: _,
    id: _,
    password: _,
    created: _
  }, _, _) do
    {:error, EmailPasswordAreInvalidError.new()}
  end

  def change_email(_, _, _) do
    {:error, ImpossibleChangeEmailError.new("Impossible change email for invalid data")}
  end

  @doc """
   Function validating password
   To validate password must check password and confirm it
  """
  @spec validate_password(Password.t(), binary) :: ok | error
  def validate_password(%Password{
    confirmed: %Confirmed{value: :true},
    confirmed_code: _,
    email: email,
    id: id,
    password: %ValuePassword{value: own_password},
    created: created
  }, maybe_own_password) when is_binary(maybe_own_password) do
    case check_password(own_password, maybe_own_password) do
      :false -> {:error, PasswordIsNotTrueError.new()}
      :true -> {
        :ok,
        %Password{
          confirmed: %Confirmed{value: :true},
          email: email,
          id: id,
          password: %ValuePassword{value: own_password},
          created: created
        }
      }
    end
  end

  def validate_password(%Password{
    confirmed: %Confirmed{value: :false},
    confirmed_code: _,
    email: _,
    id: _,
    password: _,
    created: _
  }, maybe_own_password) when is_binary(maybe_own_password) do
    {:error, HaveToConfirmError.new()}
  end

  def validate_password(%Password{
    confirmed: _,
    confirmed_code: _,
    email: _,
    id: _,
    password: _,
    created: _
  }, _) do
    {:error, PasswordIsInvalidError.new()}
  end

  def validate_password(_, _) do
    {:error, ImpossibleValidateError.new("Impossible validate password for invalid data")}
  end

  @doc """
   Function checking password
  """
  @spec check_password(binary, binary) :: boolean
  defp check_password(own_password, maybe_own_password) when is_binary(own_password) when is_binary(maybe_own_password) do
    Bcrypt.verify_pass(maybe_own_password, own_password)
  end

  defp check_password(_, _) do
    :false
  end

end
