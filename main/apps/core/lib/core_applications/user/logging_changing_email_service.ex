defmodule Core.CoreApplications.User.LoggingChangingEmailService do
  require Logger

  alias Core.CoreApplications.User.ChangingEmailService

  alias Core.CoreDomains.Domains.User.UseCases.ChangingEmail, as: ChangingEmailUseCase

  alias Core.CoreDomains.Domains.User.Commands.ChangingEmailCommand

  alias Core.CoreDomains.Domains.Password.Ports.GettingPort
  alias Core.CoreDomains.Domains.Password.Ports.GettingConfirmingCodePort
  alias Core.CoreDomains.Domains.Password.Ports.ChangingEmailPort

  alias Core.CoreApplications.LoggingHandler
  alias Core.CoreDomains.Common.Ports.Notifying

  use LoggingHandler,
    command: "ChangingEmailCommand",
    remote_node: Application.get_env(:core, :logger_user_service)[:remote_node],
    remote_supervisor: Application.get_env(:core, :logger_user_service)[:remote_supervisor],
    remote_module: Application.get_env(:core, :logger_user_service)[:remote_module]

  @spec change(
    ChangingEmailCommand.t(),
    GettingPort.t(),
    GettingConfirmingCodePort.t(),
    ChangingEmailPort.t(),
    Notifying.t()
  ) :: ChangingEmailUseCase.error() | ChangingEmailUseCase.ok()
  def change(command, getting_password_port, getting_confirming_code_port, changing_email_port, admin_notifying_port) do
    case ChangingEmailService.change(command, getting_password_port, getting_confirming_code_port, changing_email_port) do
      {:error, dto} ->
        handler_error(command, dto, admin_notifying_port)
        {:error, dto}
      {:ok, token} ->
        handle_success(command)
        {:ok, token}
    end
  end
end
