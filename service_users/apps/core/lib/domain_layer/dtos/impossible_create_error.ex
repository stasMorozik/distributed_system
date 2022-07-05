defmodule Core.DomainLayer.Dtos.ImpossibleCreateError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ImpossibleCreateError

  defstruct message: nil

  @type t :: %ImpossibleCreateError{message: binary}

  @spec new :: ImpossibleCreateError.t()
  def new do
    %ImpossibleCreateError{message: "Invalid input data"}
  end
end
