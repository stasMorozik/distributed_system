defmodule Core.DomainLayer.Domains.Product.Ports.GettingListPort do
  @moduledoc false

  alias Core.DomainLayer.Common.ValueObjects.Pagination
  alias Core.DomainLayer.Common.ValueObjects.Sorting
  alias Core.DomainLayer.Common.ValueObjects.Filtration
  alias Core.DomainLayer.Common.Dtos.ImpossibleCallError
  alias Core.DomainLayer.Common.Dtos.ImpossibleGetError

  alias Core.DomainLayer.Domains.Product.ProductEntity

  @type t :: Module

  @type ok :: {:ok, nonempty_list(ProductEntity.t())}

  @type error :: {
          :error,
          ImpossibleCallError.t()
          | ImpossibleGetError.t()
        }

  @callback get(Pagination.t(), Sorting.t(), Filtration.t()) :: ok() | error()
end
