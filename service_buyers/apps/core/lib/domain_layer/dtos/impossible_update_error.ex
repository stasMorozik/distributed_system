defmodule Core.DomainLayer.Dtos.ImpossibleUpdateError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ImpossibleUpdateError

  defstruct message: nil

  @type t :: %ImpossibleUpdateError{message: binary}

  @spec new :: ImpossibleUpdateError.t()
  def new do
    %ImpossibleUpdateError{
      message: "Invalid input data"
    }
  end
end
