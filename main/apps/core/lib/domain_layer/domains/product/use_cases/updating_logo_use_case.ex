defmodule Core.DomainLayer.Domains.Product.UseCases.UpdatingLogoUseCase do
  @moduledoc false

  alias Core.DomainLayer.Domains.Product.ProductEntity

  alias Core.DomainLayer.Common.Dtos.GettingEntityData

  alias Core.DomainLayer.Domains.Product.Ports.GettingPort

  alias Core.DomainLayer.Common.Dtos.UpdatingLogoData

  alias Core.DomainLayer.Common.Dtos.AuthorizatingData

  alias Core.DomainLayer.Domains.Product.Ports.UpdatingPort

  @type t :: Module

  @type ok :: {:ok, true}

  @type error ::
          ProductEntity.error_adding_image()
          | GettingPort.error()
          | UpdatingPort.t()

  @callback update(AuthorizatingData.t(), GettingEntityData.t(), UpdatingLogoData.t(), GettingPort.t(), UpdatingPort.t()) :: ok() | error()
end
