defmodule Core.DomainLayer.ValueObjects.Password do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Password
  alias Core.DomainLayer.Errors.DomainError

  defstruct value: nil

  @type t :: %Password{value: binary}

  @type ok :: {:ok, Password.t()}

  @type error :: {:error, DomainError.t()}

  @spec new(binary) :: ok | error
  def new(password) when is_binary(password) do
    if String.length(password) >= 5 && String.length(password) <= 10 do
      {
        :ok,
        %Password{
          value:
            Bcrypt.Base.hash_password(
              password,
              Bcrypt.Base.gen_salt(12)
            )
        }
      }
    else
      {:error, DomainError.new("Password is invalid")}
    end
  end

  def new(_) do
    {:error, DomainError.new("Password is invalid")}
  end
end
