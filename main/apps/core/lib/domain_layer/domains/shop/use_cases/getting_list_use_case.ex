defmodule Core.DomainLayer.Domains.Shop.UseCases.GettignListUseCase do
  @moduledoc false

  alias Core.DomainLayer.Domains.Shop.ShopEntity

  alias Core.DomainLayer.Common.ValueObjects.Pagination

  alias Core.DomainLayer.Domains.Shop.Ports.GettingListPort

  alias Core.DomainLayer.Domains.User.Dtos.GettingListData

  @type t :: Module

  @type ok :: {:ok, nonempty_list(ShopEntity.t())}

  @type error ::
          GettingListPort.error()
          | Pagination.error()

  @callback get(GettingListData.t(), GettingListPort.t()) :: ok() | error()
end
