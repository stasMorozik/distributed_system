defmodule Core.DomainLayer.Domains.Shop.UseCases.UpdatingLogoUseCase do
  @moduledoc false

  alias Core.DomainLayer.Domains.Shop.ShopEntity

  alias Core.DomainLayer.Domains.Shop.Ports.UpdatingPort

  alias Core.DomainLayer.Domains.Shop.Dtos.ChangingLogoData

  @type t :: Module

  @type ok :: {:ok, ShopEntity.t()}

  @type error :: UpdatingPort.error()

  @callback update(ChangingLogoData.t(), UpdatingPort.t()) :: ok() | error()
end
