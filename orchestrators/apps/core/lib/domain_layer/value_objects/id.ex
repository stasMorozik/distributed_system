defmodule Core.DomainLayer.ValueObjects.Id do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Id

  defstruct value: nil

  @type t :: %Id{value: binary}
end
