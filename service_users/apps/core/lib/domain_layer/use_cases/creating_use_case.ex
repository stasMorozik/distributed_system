defmodule Core.DomainLayer.UseCases.CreatingUseCase do
  @moduledoc false

  alias Core.DomainLayer.UserAggregate

  alias Core.DomainLayer.Ports.CreatingPort

  alias Core.DomainLayer.Ports.CreatingPort

  @type ok :: {:ok, true}

  @type error :: CreatingPort.error() | UserAggregate.error_creating()

  @callback create(UserAggregate.creating_dto(), CreatingPort.t()) :: ok() | error()
end
