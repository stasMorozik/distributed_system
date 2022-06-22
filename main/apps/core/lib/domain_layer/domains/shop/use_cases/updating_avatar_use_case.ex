defmodule Core.DomainLayer.Domains.Shop.UseCases.UpdatingAvatarUseCase do
  @moduledoc false

  alias Core.DomainLayer.Domains.Shop.ShopEntity

  alias Core.DomainLayer.Domains.Shop.Ports.UpdatingPort

  alias Core.DomainLayer.Domains.Shop.Dtos.ChangingAvatarData

  @type t :: Module

  @type ok :: {:ok, ShopEntity.t()}

  @type error :: UpdatingPort.error()

  @callback update(ChangingAvatarData.t(), UpdatingPort.t()) :: ok() | error()
end
