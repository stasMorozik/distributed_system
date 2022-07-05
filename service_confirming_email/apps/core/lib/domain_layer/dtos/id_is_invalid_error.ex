defmodule Core.DomainLayer.Dtos.IdIsInvalidError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.IdIsInvalidError

  defstruct message: nil

  @type t :: %IdIsInvalidError{message: binary}

  @spec new :: IdIsInvalidError.t()
  def new do
    %IdIsInvalidError{message: "Id is invalid"}
  end
end
