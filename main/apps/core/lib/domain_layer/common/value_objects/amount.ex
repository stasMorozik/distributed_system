defmodule Core.DomainLayer.Common.ValueObjects.Amount do
  @moduledoc false

  alias Core.DomainLayer.Common.ValueObjects.Amount

  defstruct value: nil

  @type t :: %Amount{value: binary()}

  @spec new(integer()) :: Amount.t()
  def new(amount) when is_integer(amount) do
    if amount < 0 do
      %Amount{value: 0}
    else
      %Amount{value: amount}
    end
  end

  def new(_) do
    %Amount{value: 0}
  end
end
