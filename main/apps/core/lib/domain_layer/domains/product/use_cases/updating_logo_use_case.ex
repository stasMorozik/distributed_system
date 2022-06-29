defmodule Core.DomainLayer.Domains.Product.UseCases.UpdatingLogoUseCase do
  @moduledoc false

  alias Core.DomainLayer.Domains.Product.ProductEntity

  alias Core.DomainLayer.Common.Dtos.GettingEntityData

  alias Core.DomainLayer.Domains.Product.Ports.GettingPort

  alias Core.DomainLayer.Common.Dtos.UpdatingLogoData

  alias Core.DomainLayer.Common.Dtos.AuthorizatingData

  alias Core.DomainLayer.Common.Ports.StoragingFilePort

  @type t :: Module

  @type ok :: {:ok, true}

  @type error ::
          ProductEntity.error_adding_image()
          | StoragingFilePort.error()
          | GettingPort.error()

  @callback update(AuthorizatingData.t(), GettingEntityData.t(), UpdatingLogoData.t(), GettingPort.t(), StoragingFilePort.t()) :: ok() | error()
end
