defmodule Core.DomainLayer.UseCases.GettingListProviderInvoiceUseCase do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Pagination

  alias Core.DomainLayer.ValueObjects.FiltrationProviderInvoices

  alias Core.DomainLayer.ValueObjects.SortingProviderInvoices

  alias Core.DomainLayer.ValueObjects.SplitingProviderInvoices

  alias Core.DomainLayer.ProviderInvoiceAggregate

  alias Core.DomainLayer.Ports.GettingListProviderInvoicePort

  alias Core.DomainLayer.ValueObjects.Sorting

  alias Core.DomainLayer.ValueObjects.Splitting

  alias Core.DomainLayer.ValueObjects.Pagination

  @type t :: Module

  @type ok :: {:ok, list(ProviderInvoiceAggregate.t())}

  @type error ::
          Pagination.error()
          | SortingProviderInvoices.error()
          | SplitingProviderInvoices.error()
          | FiltrationProviderInvoices.error()
          | GettingListProviderInvoicePort.error()

  @type dto_filtration :: %{
          customer: binary() | nil
        }

  @callback get(
              Pagination.creating_dto(),
              Sorting.creating_dto()   | nil,
              dto_filtration()         | nil,
              Splitting.creating_dto() | nil,
              GettingListProviderInvoicePort.t()
            ) :: ok() | error()
end
