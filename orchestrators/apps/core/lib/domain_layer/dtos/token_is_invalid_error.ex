defmodule Core.DomainLayer.Dtos.TokenIsInvalidError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.TokenIsInvalidError

  defstruct message: nil

  @type t :: %TokenIsInvalidError{message: binary}
end
