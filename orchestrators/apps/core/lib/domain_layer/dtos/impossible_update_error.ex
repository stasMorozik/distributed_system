defmodule Core.DomainLayer.Dtos.ImpossibleUpdateError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ImpossibleUpdateError

  defstruct message: nil

  @type t :: %ImpossibleUpdateError{message: binary}
end
