defmodule Core.DomainLayer.Domains.Shop.UseCases.UpdatingLogoUseCase do
  @moduledoc false

  alias Core.DomainLayer.Domains.Shop.ShopEntity

  alias Core.DomainLayer.Common.Dtos.UpdatingLogoData

  alias Core.DomainLayer.Common.Ports.StoragingFilePort

  alias Core.DomainLayer.Common.Dtos.AuthorizatingData

  alias Core.DomainLayer.Domains.Shop.Ports.GettingPort

  alias Core.DomainLayer.Common.Dtos.GettingEntityData

  @type t :: Module

  @type ok :: {:ok, true}

  @type error ::
          ShopEntity.error_changing_logo()
          | StoragingFilePort.error()
          | GettingPort.error()

  @callback update(AuthorizatingData.t(), GettingEntityData.t(), UpdatingLogoData.t(), GettingPort.t(), StoragingFilePort.t()) :: ok() | error()
end
