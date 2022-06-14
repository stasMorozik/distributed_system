defmodule Core.CoreDomains.Domains.User.UseCases.Logouting do
  alias alias Core.CoreDomains.Domains.User.Commands.LogoutingCommand

  alias alias Core.CoreDomains.Domains.Token

  @type t :: module

  @type error :: Token.error()

  @type ok :: {:ok, true}

  @callback logout(LogoutingCommand.t()) :: error | ok
end
