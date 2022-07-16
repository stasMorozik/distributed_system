defmodule Core.DomainLayer.Ports.GettingListProductPort do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ImpossibleGetError

  alias Core.DomainLayer.ProductAggregate

  alias Core.DomainLayer.ValueObjects.Pagination

  alias Core.DomainLayer.ValueObjects.FiltrationProducts

  alias Core.DomainLayer.ValueObjects.SortingProducts

  alias Core.DomainLayer.ValueObjects.SplitingProducts

  @type t :: Module

  @type ok :: {:ok, list(ProductAggregate.t())}

  @type error :: {:error, ImpossibleGetError.t()}

  @callback get(
              Pagination.t(),
              FiltrationProducts.t() | nil,
              SortingProducts.t()    | nil,
              SplitingProducts.t()   | nil
            ) :: ok() | error()
end
