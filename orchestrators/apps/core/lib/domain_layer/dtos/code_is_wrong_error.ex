defmodule Core.DomainLayer.Dtos.CodeIsWrongError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.CodeIsWrongError

  defstruct message: nil

  @type t :: %CodeIsWrongError{message: binary}
end
