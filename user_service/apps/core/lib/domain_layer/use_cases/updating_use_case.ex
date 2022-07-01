defmodule Core.DomainLayer.UseCases.UpdatingUseCase do
  @moduledoc false

  alias Core.DomainLayer.UserEntity

  alias Core.DomainLayer.Ports.UpdatingPort

  alias Core.DomainLayer.Ports.GettingPort

  alias Core.DomainLayer.ValueObjects.Id

  @type ok :: {:ok, true}

  @type error :: UpdatingPort.error() | GettingPort.error() | UserEntity.error_updating() | Id.error()

  @callback update(binary(), UserEntity.updating_dto(), GettingPort.t(), UpdatingPort.t()) :: ok() | error()
end
