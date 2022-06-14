defmodule Core.CoreApplications.User.LoggingLogoutingService do
  require Logger

  alias Core.CoreDomains.Domains.User.UseCases.Logouting, as: LogoutingUseCase
  alias Core.CoreApplications.User.LogoutingService
  alias Core.CoreDomains.Domains.User.Commands.LogoutingCommand

  alias Core.CoreApplications.LoggingHandler

  use LoggingHandler,
    command: "LogoutingCommand",
    remote_node: Application.get_env(:core, :logger_user_service)[:remote_node],
    remote_supervisor: Application.get_env(:core, :logger_user_service)[:remote_supervisor],
    remote_module: Application.get_env(:core, :logger_user_service)[:remote_module]

  @spec logout(LogoutingCommand.t()) :: LogoutingUseCase.error() | LogoutingUseCase.ok()
  def logout(command) do
    case LogoutingService.logout(command) do
      {:error, dto} ->
        handler_error(command, dto, nil)
        {:error, dto}
      {:ok, some} ->
        handle_success(command)
        {:ok, some}
    end
  end
end
