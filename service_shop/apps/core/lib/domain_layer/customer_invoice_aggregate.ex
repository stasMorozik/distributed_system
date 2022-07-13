defmodule Core.DomainLayer.CustomerInvoiceAggregate do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Price
  alias Core.DomainLayer.ValueObjects.Id
  alias Core.DomainLayer.ValueObjects.Created
  alias Core.DomainLayer.ValueObjects.Number

  alias Core.DomainLayer.Dtos.ImpossibleCreateError

  alias Core.DomainLayer.ProductAggregate
  alias Core.DomainLayer.ProviderInvoiceAggreGate
  alias Core.DomainLayer.OwnerEntity

  alias Core.DomainLayer.CustomerInvoiceAggregate

  defstruct created: nil,
            id: nil,
            price: nil,
            number: nil,
            customer: nil,
            invoices: []

  @type t :: %CustomerInvoiceAggregate{
          created: Created.t(),
          id: Id.t(),
          price: Price.t(),
          number: Number.t(),
          customer: OwnerEntity.t(),
          invoices: list(ProviderInvoiceAggreGate.t())
        }

  @type ok :: {:ok, CustomerInvoiceAggregate.t()}

  @type error_creating ::
          Price.error()
          | CustomerInvoiceAggregate.error_creating()
          | {:error, ImpossibleCreateError.t()}

  @type product_dto :: %{
          amount: integer(),
          product: ProductAggregate.t()
        }

  @type creating_dto :: %{
          customer: OwnerEntity.t(),
          products: list(product_dto())
        }

  @spec new(creating_dto()) :: ok() | error_creating()
  def new(%{} = creating_dto) when is_map(creating_dto) and is_list(creating_dto.products) do
    with false <- Enum.empty?(creating_dto.products),
         group <-
           Enum.group_by(creating_dto.products, fn dto -> dto.product.owner.email.value end)
           |> Enum.map(fn {_, list} -> list end),
         invoices <-
           Enum.map(group, fn list_dto ->
             ProviderInvoiceAggreGate.new(%{customer: creating_dto.customer, products: list_dto})
           end),
         nil <- Enum.find(invoices, fn {result, _} -> result == :error end),
         invoices <- Enum.map(invoices, fn {_, invoce} -> invoce end),
         price <-
           Enum.reduce(invoices, 0, fn invoce, acc ->
             invoce.price.value + acc
           end),
         {:ok, value_price} <- Price.new(price) do
      {
        :ok,
        %CustomerInvoiceAggregate{
          created: Created.new(),
          id: Id.new(),
          price: value_price,
          number: Number.new(),
          customer: creating_dto.customer,
          invoices: invoices
        }
      }
    else
      true -> {:error, ImpossibleCreateError.new()}
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  def new() do
    {:error, ImpossibleCreateError.new()}
  end
end

# alias Core.DomainLayer.OwnerEntity
# {:ok, owner} = OwnerEntity.new("email@gmail.com", "82594c54-da2c-4c76-b1c8-264a1bcb1458")
# alias Core.DomainLayer.ProductAggregate
# alias Core.DomainLayer.ProviderInvoiceAggreGate
# {:ok, product} = ProductAggregate.new(%{name: "test1", amount: 10, description: "test", price: 110.0, logo: "logo", images: [], owner: %{id: "57591024-abc2-4b40-95f2-35c436529c5e", email: "test1@gmail.com"}})
# {:ok, product1} = ProductAggregate.new(%{name: "test2", amount: 10, description: "test", price: 140.0, logo: "logo", images: [], owner: %{id: "0898430e-02fb-4c47-881e-63b822f1ca92", email: "test1@gmail.com"}})
# {:ok, product2} = ProductAggregate.new(%{name: "test3", amount: 10, description: "test", price: 150.0, logo: "logo", images: [], owner: %{id: "0898430e-02fb-4c47-881e-63b822f1ca92", email: "test2@gmail.com"}})
# alias Core.DomainLayer.CustomerInvoiceAggregate
# CustomerInvoiceAggregate.new(%{customer: owner, products: [ %{amount: 3, product: product}, %{amount: 2, product: product1}, %{amount: 2, product: product2} ] })
