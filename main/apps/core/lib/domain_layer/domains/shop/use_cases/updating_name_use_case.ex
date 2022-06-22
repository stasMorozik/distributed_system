defmodule Core.DomainLayer.Domains.Shop.UseCases.UpdatingNameUseCase do
  @moduledoc false

  alias Core.DomainLayer.Domains.Shop.ShopEntity

  alias Core.DomainLayer.Domains.Shop.Ports.UpdatingPort

  alias Core.DomainLayer.Domains.Shop.Dtos.ChangingNameData

  @type t :: Module

  @type ok :: {:ok, ShopEntity.t()}

  @type error ::
          ShopEntity.error_changing_name()
          | UpdatingPort.error()

  @callback update(ChangingNameData.t(), UpdatingPort.t()) :: ok() | error()
end
