defmodule GettingListProviderInvoiceAdapter do
  @moduledoc false

  import Ecto.Query
  alias Shop.Repo

  alias Core.DomainLayer.Ports.GettingListProviderInvoicePort

  alias Core.DomainLayer.Dtos.ImpossibleGetError
  alias Core.DomainLayer.ValueObjects.Pagination
  alias Core.DomainLayer.ValueObjects.FiltrationProviderInvoices
  alias Core.DomainLayer.ValueObjects.SortingProviderInvoices
  alias Core.DomainLayer.ValueObjects.SplitingProviderInvoices
  alias Core.DomainLayer.ValueObjects.Email
  alias Core.DomainLayer.ValueObjects.Sorting
  alias Core.DomainLayer.ValueObjects.Splitting

  alias Shop.ProviderInvoiceSchema
  alias Shop.ProviderInvoiceOwnerSchema
  alias Shop.OwnerSchema

  alias Utils.ProviderInvoiceToDomain

  @behaviour GettingListProviderInvoicePort

  @spec get(
              Pagination.t(),
              FiltrationProviderInvoices.t() | nil,
              SortingProviderInvoices.t()    | nil,
              SplitingProviderInvoices.t()   | nil
            ) :: GettingListProviderInvoicePort.ok() | GettingListProviderInvoicePort.error()
  def get(
        %Pagination{} = pagination,
        maybe_filtration,
        maybe_sorting,
        maybe_spliting
      ) do

    query =
      from(invoice in ProviderInvoiceSchema, as: :invoice,
        limit: ^pagination.limit,
        offset: ^pagination.offset,

        join: owners in ProviderInvoiceOwnerSchema,
        on: owners.invoice_id == invoice.id,

        join: customer in OwnerSchema,
        as: :customer,
        on: owners.customer_id == customer.id,

        join: provider in OwnerSchema,
        on: owners.provider_id == provider.id,

        preload: [
          customer: customer,
          provider: provider
        ]
      )

    case maybe_spliting != nil do
      true ->
        with {:ok, query} <- define_splitting(query, maybe_spliting) do
          list_invoice = Repo.all(query)

          {
            :ok,
            ProviderInvoiceToDomain.from_list_splitting(list_invoice)
          }
        else
          {:error, error_dto} -> {:error, error_dto}
        end
      false ->

        with {:ok, query} <- define_filtration(query, maybe_filtration),
             {:ok, query} <- define_sorting(query, maybe_sorting) do
          list_invoice = Repo.all(query)

          {
            :ok,
            ProviderInvoiceToDomain.from_list(list_invoice)
          }
        else
          {:error, error_dto} -> {:error, error_dto}
        end
    end
  end

  def get(_, _, _, _) do
    {:error, ImpossibleGetError.new()}
  end

  defp define_filtration(query, %FiltrationProviderInvoices{
    customer: %Email{value: customer}
  }) do
    {
      :ok,
      query
      |> where([customer: customer], customer.email == ^customer)
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

  defp define_splitting(query, %Splitting{
    value: :price,
    sort: :created
  }) do
    {
      :ok,
      query
      |> select(
        [invoice: invoice],
        {
          invoice,
          %{
            row_number:
              row_number()
              |> over(partition_by: invoice.price, order_by: invoice.created)
          }
        }
      )
    }
  end

  defp define_splitting(query, %Splitting{
    value: :status,
    sort: :price
  }) do
    {
      :ok,
      query
      |> select(
        [invoice: invoice],
        {
          invoice,
          %{
            row_number:
              row_number()
              |> over(partition_by: invoice.status, order_by: invoice.price)
          }
        }
      )
    }
  end

  defp define_splitting(query, %Splitting{
    value: :customer,
    sort: :price
  }) do
    {
      :ok,
      query
      |> select(
        [invoice: invoice, customer: customer],
        {
          invoice,
          %{
            row_number:
              row_number()
              |> over(partition_by: customer.email, order_by: invoice.price)
          }
        }
      )
    }
  end

  defp define_splitting(query, nil) do
    query
  end

  defp define_splitting(_, _) do
    {:error, ImpossibleGetError.new()}
  end
end
