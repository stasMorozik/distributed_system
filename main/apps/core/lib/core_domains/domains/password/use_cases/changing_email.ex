defmodule Core.CoreDomains.Domains.Password.UseCases.ChangingEmail do
  alias Core.CoreDomains.Domains.Password

  alias Core.CoreDomains.Domains.Password.Commands.ChangeEmailCommand

  alias Core.CoreDomains.Domains.Password.Ports.GettingPort
  alias Core.CoreDomains.Domains.Password.Ports.ChangingEmailPort

  @type t :: module

  @type error :: ChangingEmailPort.error()| GettingPort.error() | Password.error()

  @type ok :: {:ok, Password.t()}

  @callback change(
    ChangeEmailCommand.t(),
    GettingPort.t(),
    ChangingEmailPort.t()
  ) :: ok | error
end
