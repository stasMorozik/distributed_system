defmodule Core.DomainLayer.UseCases.UpdatingUseCase do
  @moduledoc false

  alias Core.DomainLayer.UserAggregate

  alias Core.DomainLayer.Ports.UpdatingPort

  alias Core.DomainLayer.Ports.GettingPort

  alias Core.DomainLayer.ValueObjects.Id

  @type ok :: {:ok, true}

  @type error :: UpdatingPort.error() | GettingPort.error() | UserAggregate.error_updating() | Id.error()

  @callback update(binary(), UserAggregate.updating_dto(), GettingPort.t(), UpdatingPort.t()) :: ok() | error()
end
