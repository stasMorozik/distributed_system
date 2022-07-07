defmodule Core.DomainLayer.ValueObjects.Price do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Price
  alias Core.DomainLayer.Dtos.PriceIsInvalidError

  defstruct value: nil

  @type t :: %Price{value: integer()}

  @type ok :: {:ok, Price.t()}

  @type error :: {:error, PriceIsInvalidError.t()}

  @spec new(binary) :: ok | error
  def new(pr) when is_integer(pr) do
    case pr >= 0 do
      true -> {:ok, %Price{value: pr}}
      false -> {:error, PriceIsInvalidError.new()}
    end
  end

  def new(_) do
    {:error, PriceIsInvalidError.new()}
  end
end
