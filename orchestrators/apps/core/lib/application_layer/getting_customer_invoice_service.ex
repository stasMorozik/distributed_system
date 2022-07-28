defmodule Core.ApplicationLayer.GettingCustomerInvoiceService do
  @moduledoc false

  alias Core.DomainLayer.UseCases.GettingCustomerInvoiceUseCase
  alias Core.DomainLayer.Ports.GettingCustomerInvoicePort
  alias Core.DomainLayer.Ports.ParsingJwtPort

  @behaviour GettingCustomerInvoiceUseCase

  @spec get(
          binary(),
          binary(),
          ParsingJwtPort.t(),
          GettingCustomerInvoicePort.t()
        ) :: GettingCustomerInvoiceUseCase.ok() | GettingCustomerInvoiceUseCase.error()
  def get(token, id, parsing_jwt_port, getting_customer_invoice_port) do
    with {:ok, _} <- parsing_jwt_port.parse(token),
          {:ok, invoice_entity} <- getting_customer_invoice_port.get_customer_invoice(id) do
      {:ok, invoice_entity}
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end
end
