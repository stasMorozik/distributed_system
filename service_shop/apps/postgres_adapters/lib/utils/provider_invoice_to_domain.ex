defmodule Utils.ProviderInvoiceToDomain do
  @moduledoc false

  alias Utils.ProductToDomain

  alias Core.DomainLayer.ProviderInvoiceAggregate

  alias Core.DomainLayer.ValueObjects.Price
  alias Core.DomainLayer.ValueObjects.Amount
  alias Core.DomainLayer.ValueObjects.Id
  alias Core.DomainLayer.ValueObjects.Created
  alias Core.DomainLayer.ValueObjects.Number
  alias Core.DomainLayer.ValueObjects.Status
  alias Core.DomainLayer.ValueObjects.Email

  alias Core.DomainLayer.OwnerEntity

  def to(invoice_schema) do
    %ProviderInvoiceAggregate{
      created: %Created{value: invoice_schema.created},
      id: %Id{value: invoice_schema.id},
      price: %Price{value: invoice_schema.price},
      number: %Number{value: invoice_schema.number},
      customer: %OwnerEntity{
        email: %Email{value: invoice_schema.customer.email},
        id: %Id{value: invoice_schema.customer.id},
        created: %Created{value: invoice_schema.customer.created}
      },
      status: %Status{value: invoice_schema.status},
      products:
        Enum.map(invoice_schema.products, fn {invoice_product, like_count, dislike_count} ->
          %{
            amount: %Amount{value: invoice_product.amount},
            product: ProductToDomain.to(invoice_product.product, like_count, dislike_count)
          }
        end),
      provider: %OwnerEntity{
        email: %Email{value: invoice_schema.provider.email},
        id: %Id{value: invoice_schema.provider.id},
        created: %Created{value: invoice_schema.provider.created}
      }
    }
  end
end
