defmodule Core.CoreApplications.Password.LoggingChangingPasswordService do
  require Logger

  alias Core.CoreDomains.Domains.Password.UseCases.ChanginPassword, as: ChanginPasswordUseCase

  alias Core.CoreApplications.Password.ChangingPasswordService

  alias Core.CoreDomains.Domains.Password.Commands.ChangePasswordCommand

  alias Core.CoreDomains.Domains.Password.Ports.GettingPort
  alias Core.CoreDomains.Domains.Password.Ports.ChangingPasswordPort
  alias Core.CoreDomains.Common.Ports.Notifying

  alias Core.CoreApplications.LoggingHandler

  use LoggingHandler,
    command: "ChangePasswordCommand",
    remote_node: Application.get_env(:core, :logger_password_service)[:remote_node],
    remote_supervisor: Application.get_env(:core, :logger_password_service)[:remote_supervisor],
    remote_module: Application.get_env(:core, :logger_password_service)[:remote_module]

  @spec change(
    ChangePasswordCommand.t(),
    GettingPort.t(),
    ChangingPasswordPort.t(),
    Notifying.t()
  ) :: ChanginPasswordUseCase.ok() | ChanginPasswordUseCase.error()
  def change(command, getting_port, changing_password_port, admin_notifying_port) do
    case ChangingPasswordService.change(command, getting_port, changing_password_port) do
      {:error, dto} ->
        command = hidden_values(command)
        handler_error(command, dto, admin_notifying_port)
        {:error, dto}
      {:ok, changed_password} ->
        hidden_values(command) |> handle_success()
        {:ok, changed_password}
    end
  end

  defp hidden_values(command) do
    %ChangePasswordCommand{
      id: command.id
    }
  end
end
