defmodule Core.DomainLayer.Common.ValueObjects.Amount do
  @moduledoc false

  alias Core.DomainLayer.Common.ValueObjects.Amount

  alias Core.DomainLayer.Common.Dtos.AmountIsInvalidError

  defstruct value: nil

  @type t :: %Amount{value: binary()}

  @type ok :: {:ok, Amount.t()}

  @type error :: {:error, AmountIsInvalidError.t()}

  @spec new(integer()) :: Amount.t()
  def new(amount) when is_integer(amount) do
    if amount < 0 do
      {:error, AmountIsInvalidError.new()}
    else
      {:ok, %Amount{value: amount}}
    end
  end

  def new(_) do
    {:error, AmountIsInvalidError.new()}
  end
end
