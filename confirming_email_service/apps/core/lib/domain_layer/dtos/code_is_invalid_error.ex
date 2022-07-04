defmodule Core.DomainLayer.Dtos.CodeIsInvalidError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.CodeIsInvalidError

  defstruct message: nil

  @type t :: %CodeIsInvalidError{message: binary}

  @spec new :: CodeIsInvalidError.t()
  def new do
    %CodeIsInvalidError{message: "Confirming code is invalid"}
  end
end
