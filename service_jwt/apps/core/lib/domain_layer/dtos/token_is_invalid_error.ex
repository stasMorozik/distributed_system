defmodule Core.DomainLayer.Dtos.TokenIsInvalidError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.TokenIsInvalidError

  defstruct message: nil

  @type t :: %TokenIsInvalidError{message: binary}

  @spec new :: TokenIsInvalidError.t()
  def new do
    %TokenIsInvalidError{message: "Token is invalid"}
  end
end
