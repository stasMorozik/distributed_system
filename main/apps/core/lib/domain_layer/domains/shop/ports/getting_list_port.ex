defmodule Core.DomainLayer.Domains.Shop.Ports.GettingListPort do
  @moduledoc false

  alias Core.DomainLayer.Domains.Shop.ShopEntity

  alias Core.DomainLayer.Common.ValueObjects.Pagination
  alias Core.DomainLayer.Common.ValueObjects.Sorting
  alias Core.DomainLayer.Common.ValueObjects.Filtration
  alias Core.DomainLayer.Common.Dtos.ImpossibleCallError
  alias Core.DomainLayer.Common.Dtos.ImpossibleGetError

  @type t :: Module

  @type ok :: {:ok, nonempty_list(ShopEntity.t())}

  @type error :: {
          :error,
          ImpossibleCallError.t()
          | ImpossibleGetError.t()
        }

  @callback get(Pagination.t(), Sorting.t(), Filtration.t())
end
