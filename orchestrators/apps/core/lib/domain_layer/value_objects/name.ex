defmodule Core.DomainLayer.ValueObjects.Name do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Name

  defstruct value: nil

  @type t :: %Name{value: binary}
end
