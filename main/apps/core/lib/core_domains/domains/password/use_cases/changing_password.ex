defmodule Core.CoreDomains.Domains.Password.UseCases.ChanginPassword do
  alias Core.CoreDomains.Domains.Password

  alias Core.CoreDomains.Domains.Password.Commands.ChangePasswordCommand

  alias Core.CoreDomains.Domains.Password.Ports.GettingPort
  alias Core.CoreDomains.Domains.Password.Ports.ChangingPasswordPort

  @type t :: module

  @type error :: ChangingPasswordPort.error() | GettingPort.error() | Password.error()

  @type ok :: {:ok, Password.t()}

  @callback change(
    ChangePasswordCommand.t(),
    GettingPort.t(),
    ChangingPasswordPort.t()
  ) :: ok | error
end
