defmodule Core.CoreDomains.Domains.Password.Dtos.ConfirmingCodeIsInvalidError do
  alias Core.CoreDomains.Domains.Password.Dtos.ConfirmingCodeIsInvalidError

  defstruct message: nil

  @type t :: %ConfirmingCodeIsInvalidError{message: binary}

  @spec new :: ConfirmingCodeIsInvalidError.t()
  def new() do
    %ConfirmingCodeIsInvalidError{message: "Confirming code is not valid"}
  end
end
