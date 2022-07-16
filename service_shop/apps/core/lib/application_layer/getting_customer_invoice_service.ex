defmodule Core.ApplicationLayer.GettingCustomerInvoiceService do
  @moduledoc false

  alias Core.DomainLayer.UseCases.GettingCustomerInvoiceUseCase

  alias Core.DomainLayer.Ports.GettingCustomerInvoicePort

  alias Core.DomainLayer.ValueObjects.Id

  @behaviour GettingCustomerInvoiceUseCase

  @callback get(
              binary(), GettingCustomerInvoicePort.t()
            ) :: GettingCustomerInvoiceUseCase.ok() | GettingCustomerInvoiceUseCase.error()
  def get(maybe_id, getting_customer_invoice_port) do
    with {:ok, value_id} <- Id.from_origin(maybe_id),
         {:ok, invoice_entity} <- getting_customer_invoice_port.get(value_id) do
      {:ok, invoice_entity}
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end
end
