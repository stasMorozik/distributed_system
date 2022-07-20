defmodule Core.ApplicationLayer.CreatingCustomerInvoiceService do
  @moduledoc false

  alias Core.DomainLayer.UseCases.CreatingCustomerInvoiceUseCase

  alias Core.DomainLayer.Ports.CreatingCustomerInvoicePort
  alias Core.DomainLayer.CustomerInvoiceAggregate
  alias Core.DomainLayer.Ports.GettingProductPort
  alias Core.DomainLayer.ValueObjects.Id

  @behaviour CreatingCustomerInvoiceUseCase

  @spec create(
          CreatingCustomerInvoiceUseCase.creating_dto(),
          GettingProductPort.t(),
          CreatingCustomerInvoicePort.t()
        ) :: CreatingCustomerInvoiceUseCase.ok() | CreatingCustomerInvoiceUseCase.error()
  def create(creating_dto, getting_product_port, creating_customer_invoice_port) do
    with maybe_list_id_product <- Enum.map(creating_dto.products, fn dto -> Id.from_origin(dto.product_id) end),
         nil <- Enum.find(maybe_list_id_product, fn {result, _} -> result == :error end),
         list_id_product <- Enum.map(maybe_list_id_product, fn {_, value_id} -> value_id end),
         maybe_list_product <- Enum.map(list_id_product, fn id -> getting_product_port.get(id) end),
         nil <- Enum.find(maybe_list_product, fn {result, _} -> result == :error end),
         list_product <- Enum.map(maybe_list_product, fn {_, product} -> product end),
         list_dto_with_index <- Enum.with_index(creating_dto.products),
         list_dto_product <- Enum.map(list_dto_with_index, fn {dto, index} -> %{product: Enum.fetch!(list_product, index), amount: dto.amount} end),
         {:ok, entity_invoice} <- CustomerInvoiceAggregate.new(%{customer: creating_dto.customer, products: list_dto_product}),
         {:ok, true} <- creating_customer_invoice_port.create(entity_invoice) do
      {:ok, true}
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end
end
