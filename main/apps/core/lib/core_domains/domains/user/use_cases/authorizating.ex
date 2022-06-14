defmodule Core.CoreDomains.Domains.User.UseCases.Authorizating do
  alias Core.CoreDomains.Domains.User.Commands.AuthorizatingCommand

  alias Core.CoreDomains.Domains.User.Ports.GettingPort
  alias Core.CoreDomains.Common.Ports.GettingPathFile

  alias Core.CoreDomains.Domains.Token

  alias Core.CoreDomains.Domains.User

  @type t :: module

  @type error :: Token.error() | GettingPort.error() | GettingPathFile.error()

  @type ok :: {:ok, User.t()}

  @callback authorizate(AuthorizatingCommand.t(), GettingPort.t(), GettingPathFile.t()) :: error | ok

end
