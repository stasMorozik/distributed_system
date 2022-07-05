defmodule Core.DomainLayer.UseCases.ValidatingUseCase do
  @moduledoc false

  alias Core.DomainLayer.ConfirmingCodeEntity

  alias Core.DomainLayer.Ports.GettingPort

  alias Core.DomainLayer.Ports.DeletingPort

  @type ok :: {:ok, true}

  @type error :: {
    :error,
    ConfirmingCodeEntity.error_validating()
    | GettingPort.error()
    | DeletingPort.error()
  }

  @callback validate(binary(), integer(), GettingPort.t(), DeletingPort.t()) :: ok() | error()
end
