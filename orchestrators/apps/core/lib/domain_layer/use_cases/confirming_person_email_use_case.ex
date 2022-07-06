defmodule Core.DomainLayer.UseCases.ConfirmingPersonEmailUseCase do
  @moduledoc false

  alias Core.DomainLayer.Ports.GettingPersonByEmailPort
  alias Core.DomainLayer.Ports.CreatingConfirmingCodePort
  alias Core.DomainLayer.Ports.NotifyingMailPort

  @type ok :: {:ok, true}

  @type error ::
  GettingPersonByEmailPort.error()
          | CreatingConfirmingCodePort.error()
          | NotifyingMailPort.error()

  @callback send_to_email_code(binary(), GettingPersonByEmailPort.t(), CreatingConfirmingCodePort.t(), NotifyingMailPort.t()) :: ok() | error()
end
