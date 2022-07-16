defmodule Core.DomainLayer.UseCases.GettingListCustomerInvoiceUseCase do
  @moduledoc false

  alias Core.DomainLayer.CustomerInvoiceAggregate

  alias Core.DomainLayer.ValueObjects.FiltrationCustomerInvoices

  alias Core.DomainLayer.ValueObjects.SortingCustomerInvoices

  alias Core.DomainLayer.ValueObjects.SplitingCustomerInvoices

  alias Core.DomainLayer.ValueObjects.Pagination

  alias Core.DomainLayer.Ports.GettingListCustomerInvoicePort

  alias Core.DomainLayer.ValueObjects.Sorting

  alias Core.DomainLayer.ValueObjects.Splitting

  alias Core.DomainLayer.ValueObjects.Pagination

  @type t :: Module

  @type ok :: {:ok, list(CustomerInvoiceAggregate.t())}

  @type error ::
          Pagination.error()
          | SortingCustomerInvoices.error()
          | SplitingCustomerInvoices.error()
          | FiltrationCustomerInvoices.error()
          | GettingListCustomerInvoicePort.error()

  @type dto_filtration :: %{
          customer: binary() | nil
        }

  @callback get(
              Pagination.creating_dto(),
              Sorting.creating_dto()   | nil,
              dto_filtration()         | nil,
              Splitting.creating_dto() | nil,
              GettingListCustomerInvoicePort.t()
            ) :: ok() | error()
end
