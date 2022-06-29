defmodule Core.DomainLayer.Domains.Product.UseCases.UpdatingUseCase do
  @moduledoc false

  alias Core.DomainLayer.Domains.Product.ProductEntity

  alias Core.DomainLayer.Domains.Product.Dtos.UpdatingData

  alias Core.DomainLayer.Domains.Product.Ports.UpdatingPort

  alias Core.DomainLayer.Common.Dtos.AuthorizatingData

  alias Core.DomainLayer.Domains.Product.Ports.GettingPort

  alias Core.DomainLayer.Common.Dtos.GettingEntityData

  @type t :: Module

  @type ok :: {:ok, true}

  @type error ::
          ProductEntity.error_changing_data()
          | UpdatingPort.error()

  @callback update(AuthorizatingData.t(), GettingEntityData.t(), UpdatingData.t(), GettingPort.t(), UpdatingPort.t()) :: ok() | error()
end
