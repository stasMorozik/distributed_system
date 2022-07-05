defmodule Core.DomainLayer.Dtos.IdIsInvalidError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.IdIsInvalidError

  defstruct message: nil

  @type t :: %IdIsInvalidError{message: binary}
end
