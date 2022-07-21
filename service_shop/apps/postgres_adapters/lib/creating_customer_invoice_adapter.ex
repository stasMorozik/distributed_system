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

    changeset_customer_invoice_owner =
      %CustomerInvoiceOwnerSchema{}
      |> CustomerInvoiceOwnerSchema.changeset(%{
        customer_id: entity.customer.id.value,
        invoice_id: entity.id.value
      })

    list_changeset_provider_invoice =
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

        changeset_customer_invoice_provider_invoice =
          %CustomerInvoiceProviderInvoiceSchema{}
          |> CustomerInvoiceProviderInvoiceSchema.changeset(%{
            customer_invoice_id: entity.id.value,
            provider_invoice_id: provider_invoice.id.value
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
          changeset_customer_invoice_provider_invoice,
          list_changeset_provider_invoice_porduct
        }
      end)

    case Multi.new()
         |> Multi.insert(:owners, changeset_owner, on_conflict: :nothing, conflict_target: :email)
         |> Multi.insert(:customer_invoices, changeset_customer_invoice)
         |> Multi.insert(:customer_invoices_owners, changeset_customer_invoice_owner)
         |> insert_list_provider_invoice(list_changeset_provider_invoice)
         |> Repo.transaction() do
      {:ok, _} -> {:ok, true}
      {:error, _, _, _} -> {:error, ImpossibleCreateError.new()}
    end
  end

  defp insert_list_provider_invoice(multi, list_invoice) do
    inserting_fun = fn {invoice, owners, customer_invoice, list_porduct}, multi ->
      Multi.insert(multi, {:provider_invoice, invoice.changes.id}, invoice)
      |> Multi.insert({:customer_invoice_invoices, invoice.changes.id}, customer_invoice)
      |> Multi.insert({:provider_invoice_owners, owners.changes.invoice_id}, owners)
      |> insert_list_provider_invoice_porduct(list_porduct)
    end

    Enum.reduce(
      list_invoice,
      multi,
      &inserting_fun.(&1, &2)
    )
  end

  defp insert_list_provider_invoice_porduct(multi, list_invoice) do
    inserting_fun = fn prod, multi ->
      Multi.insert(multi, {:provider_invoice_porduct, prod.changes.product_id}, prod)
    end

    Enum.reduce(list_invoice, multi, &inserting_fun.(&1, &2))
  end
end
