defmodule Core.DomainLayer.Dtos.EmailIsInvalidError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.EmailIsInvalidError

  defstruct message: nil

  @type t :: %EmailIsInvalidError{message: binary}
end
