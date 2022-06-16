defmodule Core.DomainLayer.Common.Dtos.IdIsInvalidError do
  @moduledoc false

  alias Core.DomainLayer.Common.Dtos.IdIsInvalidError

  defstruct message: nil

  @type t :: %IdIsInvalidError{message: binary}

  @spec new :: IdIsInvalidError.t()
  def new() do
    %IdIsInvalidError{message: "Id is not valid"}
  end
end
