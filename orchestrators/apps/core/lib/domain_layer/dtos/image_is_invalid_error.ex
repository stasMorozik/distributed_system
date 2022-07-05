defmodule Core.DomainLayer.Dtos.ImageIsInvalidError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ImageIsInvalidError

  defstruct message: nil

  @type t :: %ImageIsInvalidError{message: binary}
end
