defmodule Core.DomainLayer.Dtos.NameIsInvalidError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.NameIsInvalidError

  defstruct message: nil

  @type t :: %NameIsInvalidError{message: binary}
end
