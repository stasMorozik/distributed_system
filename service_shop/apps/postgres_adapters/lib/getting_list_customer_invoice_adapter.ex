defmodule GettingListCustomerInvoicesAdapter do
   @moduledoc false

   import Ecto.Query
   alias Shop.Repo

  alias Core.DomainLayer.Ports.GettingListCustomerInvoicePort
  alias Core.DomainLayer.Dtos.ImpossibleGetError

  alias Core.DomainLayer.ValueObjects.FiltrationCustomerInvoices
  alias Core.DomainLayer.ValueObjects.SortingCustomerInvoices
  alias Core.DomainLayer.ValueObjects.SplitingCustomerInvoices
  alias Core.DomainLayer.ValueObjects.Pagination
  alias Core.DomainLayer.ValueObjects.Email
  alias Core.DomainLayer.ValueObjects.Sorting

  alias Shop.CustomerInvoiceSchema
  alias Shop.CustomerInvoiceOwnerSchema
  alias Shop.OwnerSchema
  alias Shop.CustomerInvoiceProviderInvoiceSchema
  alias Shop.ProviderInvoiceSchema
  alias Shop.ProviderInvoiceOwnerSchema

  alias Utils.CustomerInvoiceToDomain

  @behaviour GettingListCustomerInvoicePort

  @spec get(
          Pagination.t(),
          FiltrationCustomerInvoices.t() | nil,
          SortingCustomerInvoices.t()    | nil,
          SplitingCustomerInvoices.t()   | nil
        ) :: GettingListCustomerInvoicePort.ok() | GettingListCustomerInvoicePort.error()
  def get(
        %Pagination{} = pagination,
        maybe_sorting,
        maybe_filtration,
        _
      ) do

    query =
      from(
        invoice in CustomerInvoiceSchema, as: :invoice,

        limit: ^pagination.limit,
        offset: ^pagination.offset,

        join: owner in CustomerInvoiceOwnerSchema,
        on: owner.invoice_id == invoice.id,
        join: customer in OwnerSchema, as: :customer,
        on: owner.customer_id == customer.id,

        join: customer_invoice in CustomerInvoiceProviderInvoiceSchema,
        on: invoice.id == customer_invoice.customer_invoice_id,

        join: provider_invoice in ProviderInvoiceSchema,
        on: customer_invoice.provider_invoice_id == provider_invoice.id,

        join: owners in ProviderInvoiceOwnerSchema,
        on: owners.invoice_id == provider_invoice.id,

        join: customer_provider_invoice in OwnerSchema,
        on: owners.customer_id == customer.id,

        join: provider in OwnerSchema, as: :provider,
        on: owners.provider_id == provider.id,

        preload: [
          customer: customer,
          provider_invoces: {customer_invoice, provider_invoice: {provider_invoice, provider: provider, customer: customer_provider_invoice}}
        ]
      )

      with  {:ok, query} <- define_filtration(query, maybe_filtration),
            {:ok, query} <- define_sorting(query, maybe_sorting) do
        list_invoice = Repo.all(query)

        {
          :ok,
          CustomerInvoiceToDomain.from_list(list_invoice)
        }
      else
        {:error, error_dto} -> {:error, error_dto}
      end
  end

  def get(_, _, _, _) do
    {:error, ImpossibleGetError.new()}
  end

  defp define_filtration(query, %FiltrationCustomerInvoices{
    provider: %Email{value: provider},
    customer: %Email{value: customer}
  }) do
    {
      :ok,
      query
      |> where([provider: provider], provider.email == ^provider)
      |> where([customer: customer], customer.email == ^customer)
    }
  end

  defp define_filtration(query, %FiltrationCustomerInvoices{
    provider: nil,
    customer: %Email{value: customer}
  }) do
    {
      :ok,
      query
      |> where([customer: customer], customer.email == ^customer)
    }
  end

  defp define_filtration(query, %FiltrationCustomerInvoices{
    provider: %Email{value: provider},
    customer: nil
  }) do
    {
      :ok,
      query
      |> where([provider: provider], provider.email == ^provider)
    }
  end

  defp define_filtration(query, nil) do
    {:ok, query}
  end

  defp define_filtration(_, _) do
    {:error, ImpossibleGetError.new()}
  end

  defp define_sorting(query, %Sorting{
    type: :asc,
    value: :created
  }) do
    {
      :ok,
      query |> order_by([invoice: invoice], asc: :created)
    }
  end

  defp define_sorting(query, %Sorting{
    type: :desc,
    value: :created
  }) do
    {
      :ok,
      query |> order_by([invoice: invoice], desc: :created)
    }
  end

  defp define_sorting(query, %Sorting{
    type: :asc,
    value: :price
  }) do
    {
      :ok,
      query |> order_by([invoice: invoice], asc: :price)
    }
  end

  defp define_sorting(query, %Sorting{
    type: :desc,
    value: :price
  }) do
    {
      :ok,
      query |> order_by([invoice: invoice], desc: :price)
    }
  end

  defp define_sorting(query, nil) do
    {:ok, query}
  end

  defp define_sorting(_, _) do
    {:error, ImpossibleGetError.new()}
  end
end
