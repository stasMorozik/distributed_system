defmodule Core.DomainLayer.Dtos.ImpossibleGetError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ImpossibleGetError

  defstruct message: nil

  @type t :: %ImpossibleGetError{message: binary}

  @spec new :: ImpossibleGetError.t()
  def new do
    %ImpossibleGetError{
      message: "Invalid input data"
    }
  end
end
