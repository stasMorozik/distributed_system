defmodule Core.DomainLayer.Common.Dtos.ConfirmingCodeIsInvalidError do
  @moduledoc false

  alias Core.DomainLayer.Common.Dtos.ConfirmingCodeIsInvalidError

  defstruct message: nil

  @type t :: %ConfirmingCodeIsInvalidError{message: binary}

  @spec new :: ConfirmingCodeIsInvalidError.t()
  def new() do
    %ConfirmingCodeIsInvalidError{
      message: "Confirming code is not valid"
    }
  end
end
