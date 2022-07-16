defmodule Core.DomainLayer.Ports.GettingListProviderInvoicePort do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ImpossibleGetError

  alias Core.DomainLayer.ProviderInvoiceAggregate

  alias Core.DomainLayer.ValueObjects.Pagination

  alias Core.DomainLayer.ValueObjects.FiltrationProviderInvoices

  alias Core.DomainLayer.ValueObjects.SortingProviderInvoices

  alias Core.DomainLayer.ValueObjects.SplitingProviderInvoices

  @type t :: Module

  @type ok :: {:ok, list(ProviderInvoiceAggregate.t())}

  @type error :: {:error, ImpossibleGetError.t()}

  @callback get(
              Pagination.t(),
              FiltrationProviderInvoices.t() | nil,
              SortingProviderInvoices.t()    | nil,
              SplitingProviderInvoices.t()   | nil
            ) :: ok() | error()
end
