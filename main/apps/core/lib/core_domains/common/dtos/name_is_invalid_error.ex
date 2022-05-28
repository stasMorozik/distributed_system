defmodule Core.CoreDomains.Common.Dtos.NameIsInvalidError do
  alias Core.CoreDomains.Common.Dtos.NameIsInvalidError

  defstruct message: nil

  @type t :: %NameIsInvalidError{message: binary}

  @spec new :: NameIsInvalidError.t()
  def new() do
    %NameIsInvalidError{message: "Name is not valid"}
  end
end