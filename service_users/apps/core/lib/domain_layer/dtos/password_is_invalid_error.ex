defmodule Core.DomainLayer.Dtos.PasswordIsInvalidError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.PasswordIsInvalidError

  defstruct message: nil

  @type t :: %PasswordIsInvalidError{message: binary}

  @spec new :: PasswordIsInvalidError.t()
  def new do
    %PasswordIsInvalidError{
      message: "Password is not valid"
    }
  end
end
