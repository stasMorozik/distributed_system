defmodule Core.CoreDomains.Domains.User.UseCases.ChangingEmail do
  alias Core.CoreDomains.Domains.User.Commands.ChangingEmailCommand

  alias Core.CoreDomains.Domains.Password.Ports.GettingPort
  alias Core.CoreDomains.Domains.Password.Ports.GettingConfirmingCodePort
  alias Core.CoreDomains.Domains.Password.Ports.ChangingEmailPort

  alias Core.CoreDomains.Domains.Token
  alias Core.CoreDomains.Domains.Password

  @type t :: module

  @type error :: Token.error() | Password.error() | GettingPort.error() | GettingConfirmingCodePort.error()

  @type ok :: {:ok, Password.t()}

  @callback change(
    ChangingEmailCommand.t(),
    GettingPort.t(),
    GettingConfirmingCodePort.t(),
    ChangingEmailPort.t()
  ) :: error | ok
end
