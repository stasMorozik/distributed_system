defmodule Core.DomainLayer.ProviderInvoiceAggreGate do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Price
  alias Core.DomainLayer.ValueObjects.Amount
  alias Core.DomainLayer.ValueObjects.Id
  alias Core.DomainLayer.ValueObjects.Created
  alias Core.DomainLayer.ValueObjects.Number
  alias Core.DomainLayer.ValueObjects.Status

  alias Core.DomainLayer.Dtos.ImpossibleCreateError
  alias Core.DomainLayer.Dtos.ImpossibleUpdateError
  alias Core.DomainLayer.Dtos.OutOfStockError
  alias Core.DomainLayer.Dtos.AlreadyHaveSentError

  alias Core.DomainLayer.ProductAggregate
  alias Core.DomainLayer.ProviderInvoiceAggreGate

  alias Core.DomainLayer.OwnerEntity

  defstruct created: nil,
            id: nil,
            price: nil,
            number: nil,
            customer: nil,
            status: nil,
            products: [],
            provider: nil

  @type product :: %{
          amount: Amount.t(),
          product: ProductAggregate.t()
        }

  @type t :: %ProviderInvoiceAggreGate{
          created: Created.t(),
          id: Id.t(),
          price: Price.t(),
          number: Number.t(),
          customer: OwnerEntity.t(),
          status: Status.t(),
          products: list(product()),
          provider: OwnerEntity.t()
        }

  @type ok :: {:ok, ProviderInvoiceAggreGate.t()}

  @type error_creating ::
          Price.error()
          | Amount.error()
          | Status.error()
          | {:error, OutOfStockError.t()}
          | {:error, ImpossibleCreateError.t()}

  @type product_dto :: %{
          amount: integer(),
          product: ProductAggregate.t()
        }

  @type creating_dto :: %{
          customer: OwnerEntity.t(),
          products: list(product_dto())
        }

  @type error_updating ::
          Status.error()
          | {:error, ImpossibleUpdateError.t()}
          | {:error, AlreadyHaveSentError.t()}

  @spec new(creating_dto()) :: ok() | error_creating()
  def new(%{} = creating_dto) when is_map(creating_dto) and is_list(creating_dto.products) do
    with false <- Enum.empty?(creating_dto.products),
         group <-
           Enum.group_by(creating_dto.products, fn dto -> dto.product.owner.email.value end)
           |> Enum.map(fn {key, _} -> key end),
         true <- length(group) == 1,
         products <-
           Enum.map(creating_dto.products, fn dto ->
             %{amount: Amount.new(dto.amount), product: dto.product}
           end),
         nil <-
           Enum.find(products, fn %{amount: {result, _}, product: _} -> result == :error end),
         products <-
           Enum.map(products, fn %{amount: {_, maybe_amount}, product: product} ->
             %{amount: maybe_amount, product: product}
           end),
         nil <- Enum.find(products, fn dto -> dto.amount.value > dto.product.amount.value end),
         price <-
           Enum.reduce(products, 0, fn %{amount: amount, product: product}, acc ->
             amount.value * product.price.value + acc
           end),
         {:ok, value_price} <- Price.new(price),
         [head | _] <- products,
         owner <- head.product.owner,
         {:ok, value_status} <- Status.new("Created") do
      {
        :ok,
        %ProviderInvoiceAggreGate{
          created: Created.new(),
          id: Id.new(),
          price: value_price,
          number: Number.new(),
          customer: creating_dto.customer,
          status: value_status,
          products: products,
          provider: owner
        }
      }
    else
      true ->
        {:error, ImpossibleCreateError.new()}

      false ->
        {:error, ImpossibleCreateError.new()}

      %{amount: %Amount{value: _}, product: product} ->
        {:error, OutOfStockError.new(product.name.value)}

      {:error, error_dto} ->
        {:error, error_dto}

      %{amount: {:error, error_dto}, product: _} ->
        {:error, error_dto}
    end
  end

  def new(_) do
    {:error, ImpossibleCreateError.new()}
  end

  @spec change_status(ProviderInvoiceAggreGate.t()) :: ok() | error_updating()
  def change_status(%ProviderInvoiceAggreGate{} = enity) do
    with true <- enity.status.value == "Created",
         {:ok, value_status} <- Status.new("Sent") do
      {:ok, %ProviderInvoiceAggreGate{enity | status: value_status}}
    else
      false -> {:error, AlreadyHaveSentError.new()}
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  def change_status(_) do
    {:error, ImpossibleUpdateError.new()}
  end
end

# alias Core.DomainLayer.OwnerEntity
# {:ok, owner} = OwnerEntity.new("email@gmail.com", "82594c54-da2c-4c76-b1c8-264a1bcb1458")
# alias Core.DomainLayer.ProductAggregate
# alias Core.DomainLayer.ProviderInvoiceAggreGate
# {:ok, product} = ProductAggregate.new(%{name: "test", amount: 10, description: "test", price: 10.0, logo: "logo", images: [], owner: %{id: "57591024-abc2-4b40-95f2-35c436529c5e", email: "test1@gmail.com"}})
# {:ok, product1} = ProductAggregate.new(%{name: "test", amount: 10, description: "test", price: 10.0, logo: "logo", images: [], owner: %{id: "0898430e-02fb-4c47-881e-63b822f1ca92", email: "test1@gmail.com"}})
# ProviderInvoiceAggreGate.new(%{customer: owner, products: [ %{amount: 1, product: product}, %{amount: 2, product: product1}] })
