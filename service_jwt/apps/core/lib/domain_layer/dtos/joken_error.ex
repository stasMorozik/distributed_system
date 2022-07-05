defmodule Core.DomainLayer.Dtos.JokenError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.JokenError

  defstruct message: nil

  @type t :: %JokenError{message: binary}

  @spec new :: JokenError.t()
  def new do
    %JokenError{message: "Joken failed"}
  end
end
