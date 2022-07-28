defmodule Core.ApplicationLayer.CreatingCustomerInvoiceService do
  @moduledoc false

  alias Core.DomainLayer.UseCases.CreatingCustomerInvoiceUseCase
  alias Core.DomainLayer.Ports.CreatingCustomerInvoicePort
  alias Core.DomainLayer.Ports.ParsingJwtPort
  alias Core.DomainLayer.Ports.NotifyingMailPort

  @behaviour CreatingCustomerInvoiceUseCase

  @spec create(
          binary(),
          list(CreatingCustomerInvoiceUseCase.product_dto()),
          ParsingJwtPort.t(),
          CreatingCustomerInvoicePort.t(),
          NotifyingMailPort.t()
        ) :: CreatingCustomerInvoiceUseCase.ok() | CreatingCustomerInvoiceUseCase.error()
  def create(
        token,
        list_dto,
        parsing_jwt_port,
        creating_customer_invoice_port,
        notifying_mail_port
      ) do
    with {:ok, claims} <- parsing_jwt_port.parse(token),
         {:ok, invoice_entity} <-
           creating_customer_invoice_port.create_invoice(%{
             customer: %{
               email: claims.email,
               id: claims.id
             },
             products: list_dto
           }),
         list_result <-
           Enum.map(
             invoice_entity.invoices,
             fn invoice ->
               notifying_mail_port.send_mail(
                 "support@gmail.com",
                 invoice.provider.email,
                 "Created invoice",
                 "Your number of invoice is #{invoice.number}"
               )
             end
           ),
         nil <- Enum.find(list_result, fn {result, _} -> result == :error end),
         {:ok, true} <-
           notifying_mail_port.send_mail(
             "support@gmail.com",
             invoice_entity.customer.email,
             "Created invoice",
             "Your number of invoice is #{invoice_entity.number}"
           ) do
      {:ok, true}
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end
end
