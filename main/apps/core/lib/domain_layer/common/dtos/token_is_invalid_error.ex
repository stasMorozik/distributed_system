defmodule Core.DomainLayer.Common.Dtos.TokenIsInvalidError do
  alias Core.DomainLayer.Common.Dtos.TokenIsInvalidError

  defstruct message: nil

  @type t :: %TokenIsInvalidError{message: binary}

  @spec new() :: TokenIsInvalidError.t()
  def new do
    %TokenIsInvalidError{message: "Ivalid token"}
  end
end
