defmodule Core.DomainLayer.Dtos.ImpossibleSendError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ImpossibleSendError

  defstruct message: nil

  @type t :: %ImpossibleSendError{message: binary}

  @spec new :: ImpossibleSendError.t()
  def new do
    %ImpossibleSendError{message: "Invalid input data"}
  end
end
