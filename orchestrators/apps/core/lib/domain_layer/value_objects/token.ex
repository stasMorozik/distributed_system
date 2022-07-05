defmodule Core.DomainLayer.ValueObjects.Token do
  @moduledoc false
  alias Core.DomainLayer.ValueObjects.Token

  defstruct value: nil

  @type t :: %Token{value: binary()}
end
