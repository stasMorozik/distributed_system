defmodule Core.DomainLayer.Dtos.MessageIsTooLongError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.MessageIsTooLongError

  defstruct message: nil

  @type t :: %MessageIsTooLongError{message: binary}

  @spec new :: MessageIsTooLongError.t()
  def new do
    %MessageIsTooLongError{message: "Message is too long"}
  end
end
