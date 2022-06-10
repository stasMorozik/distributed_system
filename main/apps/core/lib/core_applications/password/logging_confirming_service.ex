defmodule Core.CoreApplications.Password.LoggingConfirmingService do
  require Logger

  alias Core.CoreApplications.Password.ConfirmingService

  alias Core.CoreDomains.Domains.Password.UseCases.Confirming, as: ConfirmingPasswordUseCase

  alias Core.CoreDomains.Domains.Password.Commands.ConfirmCommand

  alias Core.CoreDomains.Domains.Password.Ports.GettingPort
  alias Core.CoreDomains.Domains.Password.Ports.ConfirmingPort
  alias Core.CoreDomains.Common.Ports.Notifying

  alias Core.CoreApplications.LoggingHandler

  use LoggingHandler,
    command: "ConfirmCommand",
    remote_node: Application.get_env(:core, :logger_password_service)[:remote_node],
    remote_supervisor: Application.get_env(:core, :logger_password_service)[:remote_supervisor],
    remote_module: Application.get_env(:core, :logger_password_service)[:remote_module]

  @spec confirm(
    ConfirmCommand.t(),
    GettingPort.t(),
    ConfirmingPort.t(),
    Notifying.t()
  ) :: ConfirmingPasswordUseCase.ok() | ConfirmingPasswordUseCase.error()
  def confirm(command, getting_port, confirming_password_port, admin_notifying_port) do
    case ConfirmingService.confirm(command, getting_port, confirming_password_port) do
      {:error, dto} ->
        command = hidden_values(command)
        handler_error(command, dto, admin_notifying_port)
        {:error, dto}
      {:ok, confirmed_password} ->
        hidden_values(command) |> handle_success()
        {:ok, confirmed_password}
    end
  end

  defp hidden_values(command) do
    %ConfirmCommand{
      email: command.email,
      code: command.code
    }
  end
end
