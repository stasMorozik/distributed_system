defmodule Core.DomainLayer.ValueObjects.Password do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Password

  defstruct value: nil

  @type t :: %Password{value: binary}
end
