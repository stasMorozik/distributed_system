defmodule Core.DomainLayer.Dtos.ImpossibleDeleteError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ImpossibleDeleteError

  defstruct message: nil

  @type t :: %ImpossibleDeleteError{message: binary}
end
