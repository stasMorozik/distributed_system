defmodule Core.DomainLayer.ValueObjects.PhoneNumber do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.PhoneNumber

  defstruct value: nil

  @type t :: %PhoneNumber{value: binary}
end
