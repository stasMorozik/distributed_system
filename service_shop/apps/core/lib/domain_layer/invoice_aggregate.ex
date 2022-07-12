defmodule Core.DomainLayer.InvoiceAggregate do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Price
  alias Core.DomainLayer.ValueObjects.Amount
  alias Core.DomainLayer.ValueObjects.Id
  alias Core.DomainLayer.ValueObjects.Created

  alias Core.DomainLayer.Dtos.ImpossibleCreateError
  alias Core.DomainLayer.Dtos.ImpossibleUpdateError
  alias Core.DomainLayer.Dtos.AmountIsInvalidError

  alias Core.DomainLayer.ProductAggregate
  alias Core.DomainLayer.InvoiceAggregate

  alias Core.DomainLayer.ValueObjects.Number
  alias Core.DomainLayer.OwnerEntity

  defstruct created: nil,
            id: nil,
            price: nil,
            number: nil,
            customer: nil,
            products: [],
            providers: []

  @type product :: %{
          amount: Amount.t(),
          product: ProductAggregate.t()
        }

  @type t :: %InvoiceAggregate{
          created: Created.t(),
          id: Id.t(),
          price: Price.t(),
          number: Number.t(),
          customer: OwnerEntity.t(),
          products: list(product()),
          providers: list(OwnerEntity.t())
        }

  @type ok :: {:ok, InvoiceAggregate.t()}

  @type error ::
          Price.error()
          | Amount.error()
          | {:error, ImpossibleCreateError.t()}

  @type product_dto :: %{
          amount: integer(),
          product: ProductAggregate.t()
        }

  @type creating_dto :: %{
          customer: OwnerEntity.t(),
          products: list(product_dto())
        }

  @spec new(creating_dto()) :: ok() | error()
  def new(%{} = creating_dto) when is_map(creating_dto) do
    with false <-
           Enum.any?(creating_dto.products, fn dto -> dto.amount > dto.product.amount.value end),
         products <-
           Enum.map(creating_dto.products, fn dto ->
             %{amount: Amount.new(dto.amount), product: dto.product}
           end),
         dto <-
           Enum.find(products, fn %{amount: {result, _}, product: _} -> result == :error end),
         true <- is_nil(dto),
         products <-
           Enum.map(products, fn %{amount: {_, maybe_amount}, product: product} ->
             %{amount: maybe_amount, product: product}
           end),
         price <-
           Enum.reduce(products, 0, fn %{amount: amount, product: product}, acc ->
             (amount.value * product.price.value) + acc
           end),
         {:ok, value_price} <- Price.new(price),
         uniq_products_by_owner <-
           Enum.uniq_by(products, fn %{amount: _, product: product} ->
             product.owner.email.value
           end),
         owners <-
           Enum.map(uniq_products_by_owner, fn %{amount: _, product: product} -> product.owner end) do
      {
        :ok,
        %InvoiceAggregate{
          created: Created.new(),
          id: Id.new(),
          price: value_price,
          number: Number.new(),
          products: products,
          providers: owners,
          customer: creating_dto.customer
        }
      }
    else
      true -> {:error, AmountIsInvalidError.new()}
      false -> {:error, AmountIsInvalidError.new()}
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  def new(_) do
    {:error, ImpossibleCreateError.new()}
  end
end

# alias Core.DomainLayer.OwnerEntity
# {:ok, owner} = OwnerEntity.new("email@gmail.com", "82594c54-da2c-4c76-b1c8-264a1bcb1458")
# alias Core.DomainLayer.ProductAggregate
# alias Core.DomainLayer.InvoiceAggregate
# {:ok, product} = ProductAggregate.new(%{name: "test", amount: 10, description: "test", price: 10.0, logo: "logo", images: [], owner: %{id: "57591024-abc2-4b40-95f2-35c436529c5e", email: "test@gmail.com"}})
# {:ok, product1} = ProductAggregate.new(%{name: "test", amount: 10, description: "test", price: 10.0, logo: "logo", images: [], owner: %{id: "0898430e-02fb-4c47-881e-63b822f1ca92", email: "test@gmail.com"}})
# InvoiceAggregate.new(%{customer: owner, products: [ %{amount: 1, product: product}, %{amount: 2, product: product1}] })
