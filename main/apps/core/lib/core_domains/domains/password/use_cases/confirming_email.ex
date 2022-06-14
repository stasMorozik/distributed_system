defmodule Core.CoreDomains.Domains.Password.UseCases.ConfirmingEmail do
  alias Core.CoreDomains.Domains.Password.Ports.CreatingConfirmingCodePort

  alias Core.CoreDomains.Common.Ports.Notifying

  alias Core.CoreDomains.Domains.Password.Commands.ConfirmingEmailCommand
  alias Core.CoreDomains.Domains.Password.ValueObjects.ConfirmingCode

  @type t :: module

  @type ok :: {:ok, ConfirmingCode.t()}

  @type error :: CreatingConfirmingCodePort.error() | Password.error_creating_confirming_code()

  @callback confirm(ConfirmingEmailCommand.t(), CreatingConfirmingCodePort.t(), Notifying.t()) :: error | ok
end
