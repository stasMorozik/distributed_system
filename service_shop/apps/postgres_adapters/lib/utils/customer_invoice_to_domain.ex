defmodule Utils.CustomerInvoiceToDomain do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Id
  alias Core.DomainLayer.ValueObjects.Created
  alias Core.DomainLayer.ValueObjects.Number
  alias Core.DomainLayer.ValueObjects.Price
  alias Core.DomainLayer.ValueObjects.Email

  alias Core.DomainLayer.CustomerInvoiceAggregate
  alias Core.DomainLayer.OwnerEntity

  alias Utils.ProviderInvoiceToDomain

  def to(invoice_schema) do
    %CustomerInvoiceAggregate{
      created: %Created{value: invoice_schema.created},
      id: %Id{value: invoice_schema.id},
      price: %Price{value: invoice_schema.price},
      number: %Number{value: invoice_schema.number},
      customer: %OwnerEntity{
        email: %Email{value: invoice_schema.customer.email},
        id: %Id{value: invoice_schema.customer.id},
        created: %Created{value: invoice_schema.customer.created}
      },
      invoices:
      Enum.map(
        invoice_schema.provider_invoces,
        fn customer_invoice_provider_invoice ->
          ProviderInvoiceToDomain.to(customer_invoice_provider_invoice.provider_invoice)
        end
      )
    }
  end

end
