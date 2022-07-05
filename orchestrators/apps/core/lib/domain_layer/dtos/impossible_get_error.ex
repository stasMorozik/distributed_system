defmodule Core.DomainLayer.Dtos.ImpossibleGetError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ImpossibleGetError

  defstruct message: nil

  @type t :: %ImpossibleGetError{message: binary}
end
