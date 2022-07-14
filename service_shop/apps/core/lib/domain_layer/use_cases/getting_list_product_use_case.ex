defmodule Core.DomainLayer.UseCases.GettingListProductUseCase do
  @moduledoc false

  alias Core.DomainLayer.Ports.GettingListProductPort

  alias Core.DomainLayer.ValueObjects.SortingProducts

  alias Core.DomainLayer.ValueObjects.SplitingProducts

  alias Core.DomainLayer.ValueObjects.Pagination

  alias Core.DomainLayer.ValueObjects.FiltrationProducts

  @type t :: Module

  @type ok :: {:ok, list(ProductAggregate.t())}

  @type error ::
          Pagination.error()
          | SortingProducts.error()
          | SplitingProducts.error()
          | FiltrationProducts.error()
          | GettingListProductPort.error()

  @type dto_pagination :: %{
          limit: integer(),
          offset: integer()
        }

  @type dto_sorting :: %{
          type: binary(),
          value: binary()
        }

  @type dto_filtration :: %{
          email: any(),
          name: any()
        }

  @type dto_spliting :: %{
          value: binary()
        }

  @callback get(
              dto_pagination(),
              dto_sorting()    | nil,
              dto_filtration() | nil,
              dto_spliting()   | nil,
              GettingListProductPort.t()
            ) :: ok() | error()
end
