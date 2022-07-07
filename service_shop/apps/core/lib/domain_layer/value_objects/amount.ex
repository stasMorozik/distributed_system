defmodule Core.DomainLayer.ValueObjects.Amount do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Amount
  alias Core.DomainLayer.Dtos.AmountIsInvalidError

  defstruct value: nil

  @type t :: %Amount{value: integer()}

  @type ok :: {:ok, Amount.t()}

  @type error :: {:error, AmountIsInvalidError.t()}

  @spec new(binary) :: ok | error
  def new(am) when is_integer(am) do
    case am >= 0 do
      true -> {:ok, %Amount{value: am}}
      false -> {:error, AmountIsInvalidError.new()}
    end
  end

  def new(_) do
    {:error, AmountIsInvalidError.new()}
  end
end
