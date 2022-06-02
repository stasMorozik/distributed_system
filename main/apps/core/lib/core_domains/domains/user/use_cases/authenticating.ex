defmodule Core.CoreDomains.Domains.User.UseCases.Authenticating do
  alias Core.CoreDomains.Domains.User.Commands.AuthenticatingCommand

  alias Core.CoreDomains.Domains.Password.Ports.GettingPort

  alias Core.CoreDomains.Domains.Token
  alias Core.CoreDomains.Domains.Password

  @type t :: module

  @type error :: Password.error() | Token.error() | GettingPort.error()

  @type ok :: {:ok, binary}

  @callback authenticate(AuthenticatingCommand.t(), GettingPort.t()) :: error | ok
end
