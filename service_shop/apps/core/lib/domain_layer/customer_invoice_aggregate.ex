defmodule Core.DomainLayer.CustomerInvoiceAggregate do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Price
  alias Core.DomainLayer.ValueObjects.Id
  alias Core.DomainLayer.ValueObjects.Created
  alias Core.DomainLayer.ValueObjects.Number

  alias Core.DomainLayer.Dtos.ImpossibleCreateError

  alias Core.DomainLayer.ProductAggregate
  alias Core.DomainLayer.ProviderInvoiceAggregate
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
          invoices: list(ProviderInvoiceAggregate.t())
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
          customer: %{
            email: binary(),
            id: binary()
          },
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
             ProviderInvoiceAggregate.new(%{customer: creating_dto.customer, products: list_dto})
           end),
         nil <- Enum.find(invoices, fn {result, _} -> result == :error end),
         invoices <- Enum.map(invoices, fn {_, invoce} -> invoce end),
         price <-
           Enum.reduce(invoices, 0, fn invoce, acc ->
             invoce.price.value + acc
           end),
         {:ok, value_price} <- Price.new(price),
         {:ok, entity_customer} <- OwnerEntity.new(creating_dto.customer)  do
      {
        :ok,
        %CustomerInvoiceAggregate{
          created: Created.new(),
          id: Id.new(),
          price: value_price,
          number: Number.new(),
          customer: entity_customer,
          invoices: invoices
        }
      }
    else
      true -> {:error, ImpossibleCreateError.new()}
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  def new(_) do
    {:error, ImpossibleCreateError.new()}
  end
end
