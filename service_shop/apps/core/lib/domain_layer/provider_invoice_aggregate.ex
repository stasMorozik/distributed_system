defmodule Core.DomainLayer.ProviderInvoiceAggregate do
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
  alias Core.DomainLayer.ProviderInvoiceAggregate

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

  @type t :: %ProviderInvoiceAggregate{
          created: Created.t(),
          id: Id.t(),
          price: Price.t(),
          number: Number.t(),
          customer: OwnerEntity.t(),
          status: Status.t(),
          products: list(product()),
          provider: OwnerEntity.t()
        }

  @type ok :: {:ok, ProviderInvoiceAggregate.t()}

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
          customer: %{
            email: binary(),
            id: binary()
          },
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
         {:ok, value_status} <- Status.new("Created"),
         {:ok, entity_customer} <- OwnerEntity.new(creating_dto.customer) do
      {
        :ok,
        %ProviderInvoiceAggregate{
          created: Created.new(),
          id: Id.new(),
          price: value_price,
          number: Number.new(),
          customer: entity_customer,
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

  @spec change_status(ProviderInvoiceAggregate.t()) :: ok() | error_updating()
  def change_status(%ProviderInvoiceAggregate{} = enity) do
    with true <- enity.status.value == "Created",
         {:ok, value_status} <- Status.new("Sent") do
      {:ok, %ProviderInvoiceAggregate{enity | status: value_status}}
    else
      false -> {:error, AlreadyHaveSentError.new()}
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  def change_status(_) do
    {:error, ImpossibleUpdateError.new()}
  end
end
