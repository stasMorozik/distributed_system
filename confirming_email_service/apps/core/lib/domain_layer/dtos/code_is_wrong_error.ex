defmodule Core.DomainLayer.Dtos.CodeIsWrongError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.CodeIsWrongError

  defstruct message: nil

  @type t :: %CodeIsWrongError{message: binary}

  @spec new :: CodeIsWrongError.t()
  def new do
    %CodeIsWrongError{message: "Confirming code is wrong"}
  end
end
