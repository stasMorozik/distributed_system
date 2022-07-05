defmodule Core.DomainLayer.Dtos.SurnameIsInvalidError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.SurnameIsInvalidError

  defstruct message: nil

  @type t :: %SurnameIsInvalidError{message: binary}
end
