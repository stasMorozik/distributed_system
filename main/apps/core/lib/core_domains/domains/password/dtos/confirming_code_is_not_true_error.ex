defmodule Core.CoreDomains.Domains.Password.Dtos.ConfirmingCodeIsNotTrueError do
  alias Core.CoreDomains.Domains.Password.Dtos.ConfirmingCodeIsNotTrueError

  defstruct message: nil

  @type t :: %ConfirmingCodeIsNotTrueError{message: binary}

  @spec new :: ConfirmingCodeIsNotTrueError.t()
  def new() do
    %ConfirmingCodeIsNotTrueError{message: "Wrong confirming code"}
  end
end
