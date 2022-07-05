defmodule Core.DomainLayer.UseCases.ConfirmingUserEmailUseCase do
  @moduledoc false

  alias Core.DomainLayer.Ports.GettingUserByEmailPort
  alias Core.DomainLayer.Ports.CreatingConfirmingCodePort
  alias Core.DomainLayer.Ports.NotifyingMailPort

  @type ok :: {:ok, true}

  @type error ::
          GettingUserByEmailPort.error()
          | CreatingConfirmingCodePort.error()
          | NotifyingMailPort.error()

  @callback send_to_email_code(binary(), GettingUserByEmailPort.t(), CreatingConfirmingCodePort.t(), NotifyingMailPort.t()) :: ok() | error()
end
