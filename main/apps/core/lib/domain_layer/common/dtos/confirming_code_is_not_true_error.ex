defmodule Core.DomainLayer.Common.Dtos.ConfirmingCodeIsNotTrueError do
  alias Core.DomainLayer.Common.Dtos.ConfirmingCodeIsNotTrueError

  defstruct message: nil

  @type t :: %ConfirmingCodeIsNotTrueError{message: binary}

  @spec new :: ConfirmingCodeIsNotTrueError.t()
  def new() do
    %ConfirmingCodeIsNotTrueError{message: "Wrong confirming code"}
  end
end
