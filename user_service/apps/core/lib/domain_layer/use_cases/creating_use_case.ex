defmodule Core.DomainLayer.UseCases.CreatingUseCase do
  @moduledoc false

  alias Core.DomainLayer.UserEntity

  alias Core.DomainLayer.Ports.CreatingPort

  alias Core.DomainLayer.Ports.CreatingPort

  @type ok :: {:ok, true}

  @type error :: CreatingPort.error() | UserEntity.error_creating()

  @callback create(UserEntity.creating_dto(), CreatingPort.t()) :: ok() | error()
end
