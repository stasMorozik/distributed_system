defmodule Core.DomainLayer.OrderAggregate do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Price
  alias Core.DomainLayer.ValueObjects.Amount
  alias Core.DomainLayer.ValueObjects.Id
  alias Core.DomainLayer.ValueObjects.Created

  alias Core.DomainLayer.Dtos.ImpossibleCreateError
  alias Core.DomainLayer.Dtos.ImpossibleUpdateError
  alias Core.DomainLayer.Dtos.AmountIsInvalidError

  alias Core.DomainLayer.ProductAggregate
  alias Core.DomainLayer.OrderAggregate

  alias Core.DomainLayer.ValueObjects.Number

  defstruct created: nil, id: nil, price: nil, number: nil, products: []

  @type product :: %{
          amount: Amount.t(),
          product: ProductAggregate.t()
        }

  @type t :: %OrderAggregate{
          created: Created.t(),
          id: Id.t(),
          price: Price.t(),
          number: Number.t(),
          products: list(product()),
        }

  @type ok :: {:ok, OrderAggregate.t()}

  @type error ::
          Price.error()
          | Amount.error()
          | {:error, ImpossibleCreateError.t()}

  @type creating_dto :: %{
          amount: integer(),
          product: ProductAggregate.t()
        }

  @spec new(list(creating_dto())) :: ok() | error()
  def new(products) when is_list(products) do
    with dto <- Enum.find(products, fn dto -> dto[:amount] > dto[:product].amount.value end),
         true <- is_nil(dto),
         prs = Enum.map(products, fn dto -> %{amount: Amount.new(dto.amount), product: dto.product} end),
         dto <- Enum.find(prs, fn %{amount: {result, maybe_amount}, product: product} -> result == :error end),
         true <- is_nil(dto),
         prs = Enum.map(prs, fn %{amount: {result, maybe_amount}, product: product} -> %{amount: maybe_amount, product: product} end) do

    else
      false -> {:error, AmountIsInvalidError.new()}
    end
  end

  def new(_) do
    {:error, ImpossibleCreateError.error()}
  end
end
