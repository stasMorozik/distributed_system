defmodule Core.CoreApplications.Password.LoggingChangingEmailService do
  require Logger

  alias Core.CoreDomains.Domains.Password.UseCases.ChangingEmail, as: ChangingEmailUseCase

  alias Core.CoreApplications.Password.ChangingEmailService

  alias Core.CoreDomains.Domains.Password.Commands.ChangeEmailCommand

  alias Core.CoreDomains.Domains.Password.Ports.GettingPort
  alias Core.CoreDomains.Domains.Password.Ports.ChangingEmailPort
  alias Core.CoreDomains.Common.Ports.Notifying

  alias Core.CoreApplications.LoggingHandler

  use LoggingHandler,
    command: "ChangeEmailCommand",
    remote_node: Application.get_env(:core, :logger_password_service)[:remote_node],
    remote_supervisor: Application.get_env(:core, :logger_password_service)[:remote_supervisor],
    remote_module: Application.get_env(:core, :logger_password_service)[:remote_module]

  @spec change(
    ChangeEmailCommand.t(),
    GettingPort.t(),
    ChangingEmailPort.t(),
    Notifying.t()
  ) :: ChangingEmailUseCase.ok() | ChangingEmailUseCase.error()
  def change(command, getting_port, changing_email_port, admin_notifying_port) do
    case ChangingEmailService.change(command, getting_port, changing_email_port) do
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
    %ChangeEmailCommand{
      new_email: command.new_email,
      id: command.id
    }
  end
end
