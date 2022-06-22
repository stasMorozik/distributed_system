defmodule Core.DomainLayer.Domains.Shop.UseCases.CreatingUseCase do
  @moduledoc false

  alias Core.DomainLayer.Domains.Shop.ShopEntity

  alias Core.DomainLayer.Domains.Shop.Dtos.CreatingData

  alias Core.DomainLayer.Domains.Shop.Ports.CreatingPort

  @type t :: Module

  @type ok :: {:ok, ShopEntity.t()}

  @type error ::
          ShopEntity.error_creating()
          | CreatingPort.error()

  @callback create(CreatingData.t(), CreatingPort.t()) :: ok() | error()
end
