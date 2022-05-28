defmodule Core.CoreDomains.Common.Dtos.IdIsInvalidError do
  alias Core.CoreDomains.Common.Dtos.IdIsInvalidError

  defstruct message: nil

  @type t :: %IdIsInvalidError{message: binary}

  @spec new :: IdIsInvalidError.t()
  def new() do
    %IdIsInvalidError{message: "Id is not valid"}
  end
end
