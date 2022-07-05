defmodule Core.DomainLayer.Dtos.CodeIsInvalidError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.CodeIsInvalidError

  defstruct message: nil

  @type t :: %CodeIsInvalidError{message: binary}
end
