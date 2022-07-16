defmodule Core.DomainLayer.Ports.GettingListCustomerInvoicePort do
  @moduledoc false

  alias Core.DomainLayer.CustomerInvoiceAggregate

  alias Core.DomainLayer.ValueObjects.FiltrationCustomerInvoices

  alias Core.DomainLayer.ValueObjects.SortingCustomerInvoices

  alias Core.DomainLayer.ValueObjects.SplitingCustomerInvoices

  alias Core.DomainLayer.ValueObjects.Pagination

  @type t :: Module

  @type ok :: {:ok, list(CustomerInvoiceAggregate.t())}

  @type error :: {:error, ImpossibleGetError.t()}

  @callback get(
              Pagination.t(),
              FiltrationCustomerInvoices.t() | nil,
              SortingCustomerInvoices.t()    | nil,
              SplitingCustomerInvoices.t()   | nil
            ) :: ok() | error()
end
