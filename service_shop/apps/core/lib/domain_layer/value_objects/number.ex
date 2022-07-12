defmodule Core.DomainLayer.ValueObjects.Number do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Number

  defstruct value: nil

  @type t :: %Number{value: integer()}

  @spec new :: Number.t()
  def new do
    %Number{value: Enum.random(1_0000..9_9999)}
  end
end
