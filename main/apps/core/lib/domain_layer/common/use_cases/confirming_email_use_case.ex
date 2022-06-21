defmodule Core.DomainLayer.Common.UseCases.ConfirmingEmailUseCase do
  alias Core.DomainLayer.Common.ValueObjects.ConfirmingCode

  alias Core.DomainLayer.Common.Ports.CreatingConfirmingCodePort
  alias Core.DomainLayer.Common.Dtos.ConfirmingEmailData

  @type t :: Module

  @type ok :: {:ok, ConfirmingCode.t()}

  @type error :: {
          CreatingConfirmingCodePort.error()
          | ConfirmingCode.error()
        }

  @callback confirm(ConfirmingEmailData.t(), CreatingConfirmingCodePort.t()) :: ok() | error()
end
