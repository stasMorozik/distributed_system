defmodule Core.CoreDomains.Domains.Password.UseCases.Confirming do
  alias Core.CoreDomains.Domains.Password

  alias Core.CoreDomains.Domains.Password.Commands.ConfirmCommand

  alias Core.CoreDomains.Domains.Password.Ports.GettingPort
  alias Core.CoreDomains.Domains.Password.Ports.ConfirmingPort

  @type t :: module

  @type error :: ConfirmingPort.error() | GettingPort.error() | Password.error()

  @type ok :: {:ok, Password.t()}

  @callback confirm(
    ConfirmCommand.t(),
    GettingPort.t(),
    ConfirmingPort.t()
  ) :: ok | error
end
