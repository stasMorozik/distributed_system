defmodule Core.CoreDomains.Domains.Password.Dtos.PasswordConfirmingCodeAreInvalidError do
  alias Core.CoreDomains.Domains.Password.Dtos.PasswordConfirmingCodeAreInvalidError

  defstruct message: nil

  @type t :: %PasswordConfirmingCodeAreInvalidError{message: binary}

  @spec new :: PasswordConfirmingCodeAreInvalidError.t()
  def new() do
    %PasswordConfirmingCodeAreInvalidError{message: "Password and confirming code are invalid"}
  end
end
