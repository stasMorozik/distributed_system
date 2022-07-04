defmodule Core.DomainLayer.UseCases.ValidatingUseCase do
  @moduledoc false

  alias Core.DomainLayer.ConfirmingCodeEntity

  alias Core.DomainLayer.Ports.GettingPort

  @type ok :: {:ok, true}

  @type error :: {
    :error,
    ConfirmingCodeEntity.error_validating()
    | GettingPort.error()
  }

  @callback validate(binary(), integer(), GettingPort.t()) :: ok() | error()
end
