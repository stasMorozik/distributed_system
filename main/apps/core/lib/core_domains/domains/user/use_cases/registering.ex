defmodule Core.CoreDomains.Domains.User.UseCases.Registering do
  alias Core.CoreDomains.Domains.User.Ports.CreatingPort, as: CreatingUserPort
  alias Core.CoreDomains.Domains.Password.Ports.CreatingPort, as: CreatingPasswordPort
  alias Core.CoreDomains.Domains.Password.Ports.GettingConfirmingCodePort
  alias Core.CoreDomains.Common.Ports.Notifying

  alias Core.CoreDomains.Domains.User.Commands.RegisteringCommand

  alias Core.CoreDomains.Domains.User
  alias Core.CoreDomains.Domains.Password

  @type t :: module

  @type error :: CreatingUserPort.error() | CreatingPasswordPort.error() | Password.error() | User.error() | GettingConfirmingCodePort.error()

  @type ok :: {:ok, User.t()}

  @callback register(
    RegisteringCommand.t(),
    GettingConfirmingCodePort.t(),
    CreatingUserPort.t(),
    CreatingPasswordPort.t(),
    Notifying.t()
  ) :: ok | error
end
