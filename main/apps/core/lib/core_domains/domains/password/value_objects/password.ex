defmodule Core.CoreDomains.Domains.Password.ValueObjects.Password do
  alias Core.CoreDomains.Domains.Password.ValueObjects.Password
  alias Core.CoreDomains.Domains.Password.Dtos.PasswordIsInvalidError

  defstruct value: nil

  @type t :: %Password{value: binary}

  @type ok ::
  {
    :ok,
    Password.t()
  }

  @type error ::
  {
    :error,
    PasswordIsInvalidError.t()
  }

  @spec new(binary) :: ok | error
  def new(password) when is_binary(password) do
    if String.length(password) >= 5 && String.length(password) <= 10 do
      {:ok, %Password{value: Bcrypt.Base.hash_password(password, Bcrypt.Base.gen_salt(12))}}
    else
      {:error, PasswordIsInvalidError.new()}
    end
  end

  def new(_) do
    {:error, PasswordIsInvalidError.new()}
  end
end
