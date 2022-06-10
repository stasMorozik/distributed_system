defmodule Core.CoreApplications.User.LoggingAuthenticatingService do
  require Logger

  alias Core.CoreApplications.User.AuthenticatingService

  alias Core.CoreDomains.Domains.User.UseCases.Authenticating, as: AuthenticatingUserUseCase

  alias Core.CoreDomains.Domains.User.Commands.AuthenticatingCommand

  alias Core.CoreDomains.Domains.Password.Ports.GettingPort
  alias Core.CoreDomains.Common.Ports.Notifying

  alias Core.CoreApplications.LoggingHandler

  use LoggingHandler,
    command: "AuthenticatingCommand",
    remote_node: Application.get_env(:core, :logger_user_service)[:remote_node],
    remote_supervisor: Application.get_env(:core, :logger_user_service)[:remote_supervisor],
    remote_module: Application.get_env(:core, :logger_user_service)[:remote_module]

  @spec authenticate(AuthenticatingCommand.t(), GettingPort.t(), Notifying.t()) :: AuthenticatingUserUseCase.error() | AuthenticatingUserUseCase.ok()
  def authenticate(command, getting_password_port, admin_notifying_port) do
    case AuthenticatingService.authenticate(command, getting_password_port) do
      {:error, dto} ->
        command = hidden_values(command)
        handler_error(command, dto, admin_notifying_port)
        {:error, dto}
      {:ok, token} ->
        hidden_values(command) |> handle_success()
        {:ok, token}
    end
  end

  defp hidden_values(command) do
    %AuthenticatingCommand{
      email: command.email
    }
  end
end
