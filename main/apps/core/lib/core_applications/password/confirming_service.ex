defmodule Core.CoreApplications.Password.ConfirmingService do
  alias Core.CoreDomains.Domains.Password.UseCases.Confirming, as: ConfirmingPasswordUseCase

  alias Core.CoreDomains.Domains.Password.Commands.ConfirmCommand

  alias Core.CoreDomains.Domains.Password.Ports.GettingPort
  alias Core.CoreDomains.Domains.Password.Ports.ConfirmingPort

  alias Core.CoreDomains.Domains.Password

  @behaviour ConfirmingPasswordUseCase

  @spec confirm(
    ConfirmCommand.t(),
    GettingPort.t(),
    ConfirmingPort.t()
  ) :: ConfirmingPasswordUseCase.ok() | ConfirmingPasswordUseCase.error()
  def confirm(command, getting_port, confirming_password_port) do
    case getting_port.get(command.email) do
      {:error, dto} -> {:error, dto}
      {:ok, password} ->
        case Password.confirm(password, command.password, command.code) do
          {:error, dto} -> {:error, dto}
          {:ok, confirmed_password} -> confirming_password_port.confirm(confirmed_password)
        end
    end
  end

end
