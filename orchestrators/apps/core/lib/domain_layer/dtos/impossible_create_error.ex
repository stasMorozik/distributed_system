defmodule Core.DomainLayer.Dtos.ImpossibleCreateError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ImpossibleCreateError

  defstruct message: nil

  @type t :: %ImpossibleCreateError{message: binary}
end
