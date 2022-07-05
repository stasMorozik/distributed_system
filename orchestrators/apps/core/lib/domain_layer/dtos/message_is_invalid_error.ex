defmodule Core.DomainLayer.Dtos.MessageIsInvalidError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.MessageIsInvalidError

  defstruct message: nil

  @type t :: %MessageIsInvalidError{message: binary}
end
