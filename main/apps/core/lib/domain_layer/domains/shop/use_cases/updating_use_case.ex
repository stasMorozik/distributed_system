defmodule Core.DomainLayer.Domains.Shop.UseCases.UpdatingUseCase do
  @moduledoc false

  alias Core.DomainLayer.Domains.Shop.ShopEntity

  alias Core.DomainLayer.Domains.Shop.Dtos.UpdatingData

  alias Core.DomainLayer.Domains.Shop.Ports.UpdatingPort

  @type t :: Module

  @type ok :: {:ok, ShopEntity.t()}

  @type error ::
          ShopEntity.error_changing_name()
          | UpdatingPort.error()

  @callback update(UpdatingData.t(), UpdatingPort.t()) :: ok() | error()
end
