defmodule Core.DomainLayer.UseCases.CreatingUseCase do
  @moduledoc false

  alias Core.DomainLayer.BuyerEntity

  alias Core.DomainLayer.Ports.CreatingPort

  alias Core.DomainLayer.Ports.CreatingPort

  @type ok :: {:ok, true}

  @type error :: CreatingPort.error() | BuyerEntity.error_creating()

  @callback create(BuyerEntity.creating_dto(), CreatingPort.t()) :: ok() | error()
end
