defmodule Core.CoreDomains.Domains.Password.Dtos.PasswordIsInvalidError do
  alias Core.CoreDomains.Domains.Password.Dtos.PasswordIsInvalidError

  defstruct message: nil

  @type t :: %PasswordIsInvalidError{message: binary}

  @spec new :: PasswordIsInvalidError.t()
  def new() do
    %PasswordIsInvalidError{message: "Password is not valid"}
  end
end
