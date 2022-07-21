defmodule CreatingCustomerInvoiceAdapter do
  @moduledoc false

  alias Ecto.Multi
  alias Shop.Repo

  alias Shop.OwnerSchema
  alias Shop.CustomerInvoiceSchema
  alias Shop.CustomerInvoiceProviderInvoiceSchema
  alias Shop.CustomerInvoiceOwnerSchema
  alias Shop.ProviderInvoiceSchema
  alias Shop.ProviderInvoiceOwnerSchema
  alias Shop.ProviderInvoiceProductShema

  alias Core.DomainLayer.Ports.CreatingCustomerInvoicePort

  alias Core.DomainLayer.CustomerInvoiceAggregate
  alias Core.DomainLayer.Dtos.ImpossibleCreateError

  @spec create(CustomerInvoiceAggregate.t()) ::
          CreatingCustomerInvoicePort.ok() | CreatingCustomerInvoicePort.error()
  def create(%CustomerInvoiceAggregate{} = entity) do
    changeset_owner =
      %OwnerSchema{}
      |> OwnerSchema.changeset(%{
        email: entity.customer.email.value,
        created: entity.customer.created.value,
        id: entity.customer.id.value
      })

    changeset_customer_invoice =
      %CustomerInvoiceSchema{}
      |> CustomerInvoiceSchema.changeset(%{
        number: entity.number.value,
        created: entity.created.value,
        price: entity.price.value,
        id: entity.id.value
      })

    changeset_custmer_invoice_owner = %CustomerInvoiceOwnerSchema{} |> CustomerInvoiceOwnerSchema.changeset(%{
      customer_id: entity.customer.id.value,
      invoice_id: entity.id.value
    })

    list_changeset_provider_ivoice =
      Enum.map(entity.invoices, fn provider_invoice ->
        changeset_provider_invoice =
          %ProviderInvoiceSchema{}
          |> ProviderInvoiceSchema.changeset(%{
            created: provider_invoice.created.value,
            number: provider_invoice.number.value,
            price: provider_invoice.price.value,
            status: provider_invoice.status.value,
            id: provider_invoice.id.value
          })

        changeset_provider_invoice_owners =
          %ProviderInvoiceOwnerSchema{}
          |> ProviderInvoiceOwnerSchema.changeset(%{
            provider_id: provider_invoice.provider.id.value,
            customer_id: provider_invoice.customer.id.value,
            invoice_id: provider_invoice.id.value
          })

        list_changeset_provider_invoice_porduct =
          Enum.map(provider_invoice.products, fn product_invoice ->
            %ProviderInvoiceProductShema{}
            |> ProviderInvoiceProductShema.changeset(%{
              invoice_id: provider_invoice.id.value,
              product_id: product_invoice.product.id.value,
              amount: product_invoice.amount.value
            })
          end)

        {
          changeset_provider_invoice,
          changeset_provider_invoice_owners,
          list_changeset_provider_invoice_porduct
        }
      end)

      list_changeset_provider_ivoice
  end
end
