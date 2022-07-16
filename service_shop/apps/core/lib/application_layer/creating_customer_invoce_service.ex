defmodule Core.ApplicationLayer.CreatingCustomerInvoiceService do
  @moduledoc false

  alias Core.DomainLayer.UseCases.CreatingCustomerInvoiceUseCase

  alias Core.DomainLayer.Ports.CreatingCustomerInvoicePort
  alias Core.DomainLayer.CustomerInvoiceAggregate

  @behaviour CreatingCustomerInvoiceUseCase

  @spec create(
          CustomerInvoiceAggregate.creating_dto(),
          CreatingCustomerInvoicePort.t()
        ) :: CreatingCustomerInvoiceUseCase.ok() | CreatingCustomerInvoiceUseCase.error()
  def create(dto, creating_customer_invoice_port) do
    with {:ok, entity_invoice} <- CustomerInvoiceAggregate.new(dto),
         {:ok, true} <- creating_customer_invoice_port.create(entity_invoice) do
      {:ok, true}
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end
end
