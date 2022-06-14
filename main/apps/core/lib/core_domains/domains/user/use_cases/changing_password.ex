defmodule Core.CoreDomains.Domains.User.UseCases.ChangingPassword do
  alias Core.CoreDomains.Domains.User.Commands.ChangingPasswordCommand

  alias Core.CoreDomains.Domains.Password.Ports.GettingPort

  alias Core.CoreDomains.Domains.Token
  alias Core.CoreDomains.Domains.Password

  @type t :: module

  @type error :: Token.error() | Password.error() | GettingPort.error()

  @type ok :: {:ok, Password.t()}

  @callback change(ChangingPasswordCommand.t(), GettingPort.t()) :: error | ok
end
