defmodule Core.DomainLayer.UseCases.CreatingUseCase do
  @moduledoc false

  alias Core.DomainLayer.ConfirmingCodeEntity

  alias Core.DomainLayer.Ports.GettingPort

  alias Core.DomainLayer.Ports.UpdatingPort

  alias Core.DomainLayer.Ports.CreatingPort

  @type ok :: {:ok, integer()}

  @type error :: {
          :error,
          ConfirmingCodeEntity.error_from_origin()
          | ConfirmingCodeEntity.error_creating()
          | CreatingPort.error()
          | UpdatingPort.error()
        }

  @callback create(binary(), GettingPort.t(), UpdatingPort.t(), CreatingPort.t()) :: ok() | error()
end
