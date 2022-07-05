defmodule Core.DomainLayer.Dtos.MessageIsTooLongError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.MessageIsTooLongError

  defstruct message: nil

  @type t :: %MessageIsTooLongError{message: binary}
end
