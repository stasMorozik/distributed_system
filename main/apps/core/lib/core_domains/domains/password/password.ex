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
  alias Core.CoreDomains.Domains.Password.Dtos.PasswordIsNotTrueError
  alias Core.CoreDomains.Domains.Password.Dtos.ConfirmingCodeIsNotTrueError
  alias Core.CoreDomains.Domains.Password.Dtos.ImpossibleValidateError
  alias Core.CoreDomains.Domains.Password.Dtos.HaveToConfirmError

  alias Core.CoreDomains.Common.Dtos.ImpossibleUpdateError
  alias Core.CoreDomains.Common.Dtos.ImpossibleCreateError

  defstruct id: nil, password: nil,  email: nil, confirmed: nil, created: nil

  @type t :: %Password{
    confirmed: Confirmed.t(),
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

  @type error_creating_password ::
  {
    :error,
    EmailIsInvalidError.t()             |
    PasswordIsInvalidError.t()          |
    ImpossibleCreateError.t()           |
    ConfirmingCodeIsInvalidError.t()    |
    ConfirmingCodeIsNotTrueError.t()    |
    EmailPasswordAreInvalidError.t()
  }

  @type ok_creating_confirming_code ::
  {
    :ok,
    ConfirmingCode.t()
  }

  @type error_creating_confirming_code ::
  {
    :error,
    EmailIsInvalidError.t()
  }

  @type error_changing_email ::
  {
    :error,
    EmailIsInvalidError.t()             |
    ConfirmingCodeIsInvalidError.t()    |
    ConfirmingCodeIsNotTrueError.t()    |
    HaveToConfirmError.t()              |
    ImpossibleUpdateError.t()
  }

  @type error_changing_password ::
  {
    :error,
    PasswordIsNotTrueError.t() |
    HaveToConfirmError.t()     |
    ImpossibleUpdateError.t()  |
    PasswordIsInvalidError.t()
  }

  @type error_validating_password ::
  {
    :error,
    PasswordIsNotTrueError,t() |
    PasswordIsInvalidError.t() |
    HaveToConfirmError.t()     |
    ImpossibleValidateError.t()
  }

  @doc """
   Function creating confirming code
  """
  @spec create_code(binary) :: ok_creating_confirming_code | error_creating_confirming_code
  def create_code(email) when is_binary(email) do
    case ConfirmingCode.new(email) do
      {:error, dto} -> {:error, dto}
      {:ok, value_code} -> {:ok, value_code}
    end
  end

  def create_code(_) do
    {:error, EmailIsInvalidError.new()}
  end

  @doc """
   Function creating password
  """
  @spec create(binary, binary, integer, ConfirmingCode.t()) :: ok | error_creating_password
  def create(email, password, maybe_own_code, %ConfirmingCode{code: own_code, email: _}) when
    is_binary(email) and
    is_binary(password)and
    is_integer(maybe_own_code) do

    {result_validate_email, maybe_value_email} = Email.new(email)
    {result_validate_password, maybe_value_password} = ValuePassword.new(password)
    checked_code = maybe_own_code == own_code

    cond do
      result_validate_email == :error && result_validate_password == :error -> {:error, EmailPasswordAreInvalidError.new()}
      result_validate_email == :error -> {result_validate_email, maybe_value_email}
      result_validate_password == :error -> {result_validate_password, maybe_value_password}
      checked_code == :false -> {:error, ConfirmingCodeIsNotTrueError.new()}
      true -> {
        :ok,
        %Password {
          id: Id.new(),
          password: maybe_value_password,
          email: maybe_value_email,
          confirmed: Confirmed.new(),
          created: Created.new()
        }
      }
    end
  end

  def create(email, password, maybe_own_code, _) when
    is_binary(email) and
    is_binary(password)and
    is_integer(maybe_own_code) do
      {:error, ConfirmingCodeIsInvalidError.new()}
  end

  def create(email, password, _, %ConfirmingCode{code: _, email: _}) when
    is_binary(email) and
    is_binary(password) do
      {:error, ConfirmingCodeIsInvalidError.new()}
  end

  def create(email, _, maybe_own_code, %ConfirmingCode{code: _, email: _}) when
    is_binary(email) and
    is_integer(maybe_own_code) do
    {:error, PasswordIsInvalidError.new()}
  end

  def create(_, password, maybe_own_code, %ConfirmingCode{code: _, email: _}) when
    is_binary(password) and
    is_integer(maybe_own_code) do
    {:error, EmailIsInvalidError.new()}
  end

  def create(_, _, maybe_own_code, %ConfirmingCode{code: _, email: _}) when is_integer(maybe_own_code) do
    {:error, EmailPasswordAreInvalidError.new()}
  end

  def create(_, _, _, _) do
    {:error, ImpossibleCreateError.new("Impossible create password for invalid data")}
  end

  @doc """
   Function changing password
   To change password must check it and confirm it
  """
  @spec change_password(Password.t(), binary, binary) :: ok | error_changing_password
  def change_password(%Password{
    confirmed: %Confirmed{value: :true},
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
    email: _,
    id: _,
    password: _,
    created: _
  }, maybe_own_password, new_password) when is_binary(maybe_own_password) and is_binary(new_password) do
    {:error, HaveToConfirmError.new()}
  end

  def change_password(%Password{
    confirmed: _,
    email: _,
    id: _,
    password: _,
    created: _
  }, _, _) do
    {:error, PasswordIsInvalidError.new()}
  end

  def change_password(_, _) do
    {:error, ImpossibleUpdateError.new("Impossible change password for invalid data")}
  end

  @doc """
   Function changing email
   To change email must check password and confirm it
  """
  @spec change_email(Password.t(), ConfirmingCode.t(), binary, binary) :: ok | error_changing_email
  def change_email(
    %Password{
      confirmed: %Confirmed{value: :true},
      email: _,
      id: id,
      password: password,
      created: created
    },
    %ConfirmingCode{code: own_code, email: _},
    new_email,
    maybe_own_code
  ) when is_binary(new_email) and is_integer(maybe_own_code) do
    case maybe_own_code == own_code do
      :false -> {:error, ConfirmingCodeIsNotTrueError.new()}
      :true ->
        case Email.new(new_email) do
          {:error, dto} -> {:error, dto}
          {:ok, value_email} -> {
            :ok,
            %Password{
              confirmed: %Confirmed{value: :true},
              email: value_email,
              id: id,
              password: password,
              created: created
            },
          }
        end
    end
  end

  def change_email(
    %Password{
      confirmed: %Confirmed{value: :false},
      email: _,
      id: _,
      password: _,
      created: _
    },
    %ConfirmingCode{code: _, email: _},
    new_email,
    maybe_own_code
  ) when is_binary(new_email) and is_integer(maybe_own_code) do
    {:error, HaveToConfirmError.new()}
  end

  def change_email(
    %Password{
      confirmed: %Confirmed{value: :true},
      email: _,
      id: _,
      password: _,
      created: _
    },
    %ConfirmingCode{code: _, email: _},
    new_email,
    _
  ) when is_binary(new_email) do
    {:error, ConfirmingCodeIsInvalidError.new()}
  end

  def change_email(
    %Password{
      confirmed: %Confirmed{value: :true},
      email: _,
      id: _,
      password: _,
      created: _
    },
    _,
    new_email,
    maybe_own_code
  ) when is_binary(new_email) and is_integer(maybe_own_code) do
    {:error, ConfirmingCodeIsInvalidError.new()}
  end

  def change_email(
    %Password{
      confirmed: %Confirmed{value: :true},
      email: _,
      id: _,
      password: _,
      created: _
    },
    %ConfirmingCode{code: _, email: _},
    _,
    maybe_own_code
  ) when is_integer(maybe_own_code) do
    {:error, EmailIsInvalidError.new()}
  end

  def change_email(_, _, _, _) do
    {:error, ImpossibleUpdateError.new("Impossible change email for invalid data")}
  end

  @doc """
   Function validating password
  """
  @spec validate_password(Password.t(), binary) :: ok | error_validating_password
  def validate_password(%Password{
    confirmed: %Confirmed{value: :true},
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
    email: _,
    id: _,
    password: _,
    created: _
  }, maybe_own_password) when is_binary(maybe_own_password) do
    {:error, HaveToConfirmError.new()}
  end

  def validate_password(%Password{
    confirmed: _,
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

  #Function checking password
  @spec check_password(binary, binary) :: boolean
  defp check_password(own_password, maybe_own_password) when is_binary(own_password) when is_binary(maybe_own_password) do
    Bcrypt.verify_pass(maybe_own_password, own_password)
  end

  defp check_password(_, _) do
    :false
  end

end
