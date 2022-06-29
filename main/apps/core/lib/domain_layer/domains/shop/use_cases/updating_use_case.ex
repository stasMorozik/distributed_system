defmodule Core.DomainLayer.Domains.Shop.UseCases.UpdatingUseCase do
  @moduledoc false

  alias Core.DomainLayer.Domains.Shop.ShopEntity

  alias Core.DomainLayer.Domains.Shop.Dtos.UpdatingData

  alias Core.DomainLayer.Domains.Shop.Ports.UpdatingPort

  alias Core.DomainLayer.Common.Dtos.AuthorizatingData

  alias Core.DomainLayer.Domains.Shop.Ports.GettingPort

  alias Core.DomainLayer.Common.Dtos.GettingEntityData

  @type t :: Module

  @type ok :: {:ok, true}

  @type error ::
          ShopEntity.error_changing_data()
          | UpdatingPort.error()
          | GettingPort.error()

  @callback update(AuthorizatingData.t(), GettingEntityData.t(), UpdatingData.t(), GettingPort.t(), UpdatingPort.t()) :: ok() | error()
end
