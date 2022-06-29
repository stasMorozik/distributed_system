defmodule Core.DomainLayer.Domains.Shop.UseCases.CreatingUseCase do
  @moduledoc false

  alias Core.DomainLayer.Domains.Shop.ShopEntity

  alias Core.DomainLayer.Domains.Shop.Dtos.CreatingData

  alias Core.DomainLayer.Common.Dtos.AuthorizatingData

  alias Core.DomainLayer.Domains.Shop.Ports.CreatingPort

  @type t :: Module

  @type ok :: {:ok, true}

  @type error ::
          ShopEntity.error_creating()
          | CreatingPort.error()

  @callback create(AuthorizatingData.t(), CreatingData.t(), CreatingPort.t()) :: ok() | error()
end
