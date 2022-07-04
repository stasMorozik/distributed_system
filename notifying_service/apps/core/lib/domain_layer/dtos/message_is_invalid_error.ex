defmodule Core.DomainLayer.Dtos.MessageIsInvalidError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.MessageIsInvalidError

  defstruct message: nil

  @type t :: %MessageIsInvalidError{message: binary}

  @spec new :: MessageIsInvalidError.t()
  def new do
    %MessageIsInvalidError{message: "Message is invalid"}
  end
end
