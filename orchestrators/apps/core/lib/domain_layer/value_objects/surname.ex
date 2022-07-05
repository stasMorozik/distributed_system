defmodule Core.DomainLayer.ValueObjects.Surname do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Surname

  defstruct value: nil

  @type t :: %Surname{value: binary}
end
