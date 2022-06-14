defmodule Core.CoreApplications.Password.LoggingConfirmingEmailService do
  require Logger

  alias Core.CoreApplications.LoggingHandler

  alias Core.CoreDomains.Domains.Password.UseCases.ConfirmingEmail, as: ConfirmingEmailUseCase

  alias Core.CoreApplications.Password.ConfirmingEmailService

  alias Core.CoreDomains.Domains.Password.Commands.ConfirmingEmailCommand

  alias Core.CoreDomains.Domains.Password.Ports.CreatingConfirmingCodePort

  alias Core.CoreDomains.Common.Ports.Notifying

  use LoggingHandler,
    command: "ConfirmingEmailCommand",
    remote_node: Application.get_env(:core, :user_logger_service)[:remote_node],
    remote_supervisor: Application.get_env(:core, :user_logger_service)[:remote_supervisor],
    remote_module: Application.get_env(:core, :user_logger_service)[:remote_module]

  @spec confirm(ConfirmingEmailCommand.t(), CreatingConfirmingCodePort.t(), Notifying.t(), Notifying.t()) :: ConfirmingEmailUseCase.error() | ConfirmingEmailUseCase.ok()
  def confirm(command, creating_confirming_code_port, notifying_port, admin_notifying_port) do
    case ConfirmingEmailService.confirm(command, creating_confirming_code_port, notifying_port) do
      {:error, dto} ->
        handler_error(command, dto, admin_notifying_port)
        {:error, dto}
      {:ok, created_code} ->
        handle_success(command)
        {:ok, created_code}
    end
  end
end
