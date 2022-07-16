defmodule Core.DomainLayer.UseCases.GettingListProductUseCase do
  @moduledoc false

  alias Core.DomainLayer.Ports.GettingListProductPort

  alias Core.DomainLayer.ValueObjects.SortingProducts

  alias Core.DomainLayer.ValueObjects.SplitingProducts

  alias Core.DomainLayer.ValueObjects.FiltrationProducts

  alias Core.DomainLayer.ValueObjects.Sorting

  alias Core.DomainLayer.ValueObjects.Splitting

  alias Core.DomainLayer.ValueObjects.Pagination

  @type t :: Module

  @type ok :: {:ok, list(ProductAggregate.t())}

  @type error ::
          Pagination.error()
          | SortingProducts.error()
          | SplitingProducts.error()
          | FiltrationProducts.error()
          | GettingListProductPort.error()

  @type dto_filtration :: %{
          email: binary() | nil,
          name: binary()  | nil
        }

  @callback get(
              Pagination.creating_dto(),
              Sorting.creating_dto()   | nil,
              dto_filtration()         | nil,
              Splitting.creating_dto() | nil,
              GettingListProductPort.t()
            ) :: ok() | error()
end
