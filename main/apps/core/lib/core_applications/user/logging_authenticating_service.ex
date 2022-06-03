defmodule Core.CoreApplications.User.LoggingAuthenticatingService do
  alias Jason, as: JSON

  alias Core.CoreApplications.User.Logger

  alias Core.CoreApplications.User.AuthenticatingService

  alias Core.CoreDomains.Domains.User.UseCases.Authenticating, as: AuthenticatingUserUseCase

  alias Core.CoreDomains.Domains.User.Commands.AuthenticatingCommand

  alias Core.CoreDomains.Domains.Password.Ports.GettingPort
  alias Core.CoreDomains.Common.Ports.Notifying

  alias Core.CoreDomains.Domains.Password.Dtos.ImpossibleGetError

  @spec authenticate(AuthenticatingCommand.t(), GettingPort.t(), Notifying.t()) :: AuthenticatingUserUseCase.error() | AuthenticatingUserUseCase.ok()
  def authenticate(command, getting_password_port, admin_notifying_port) do
    case AuthenticatingService.authenticate(command, getting_password_port) do
      {:error, dto} ->
        command = hidden_values(command)
        handler_error(admin_notifying_port, command, dto)
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

  defp handle_success(command) do
    case JSON.encode(Map.from_struct(command)) do
      {:ok, json} -> Logger.info("Node - #{node()}. AuthenticatingCommand - #{json}. Ok.")
      {:error, e} -> Logger.error("#{node()} #{e}. Ok.")
    end
  end

  defp handler_error(admin_notifying_port, command, %ImpossibleGetError{message: message}) do
    case JSON.encode(Map.from_struct(command)) do
      {:ok, json} ->
        Logger.error("Node - #{node()}. Remote Node - #{Application.get_env(:adapters_user, :remote_node)}. AuthenticatingCommand - #{json}. Error - #{message}")
        admin_notifying_port.notify("@MyComapnyDev", "Error", "Node - #{node()}. Remote Node - #{Application.get_env(:adapters_user, :remote_node)}. AuthenticatingCommand - #{json}. Error - #{message}")
      {:error, _} ->
        Logger.error("Node - #{node()}. Remote Node - #{Application.get_env(:adapters_user, :remote_node)}. Error - #{message}")
        admin_notifying_port.notify("@MyComapnyDev", "Error", "Node - #{node()}. Remote Node - #{Application.get_env(:adapters_user, :remote_node)}. Error - #{message}")
    end
  end

  defp handler_error(_, command, some_error_dto) do
    case JSON.encode(Map.from_struct(command)) do
      {:ok, json} ->
        Logger.info("Node - #{node()}. AuthenticatingCommand - #{json}. Error - #{some_error_dto.message}")
      {:error, _} ->
        Logger.error("Node - #{node()}. Error - #{some_error_dto.message}")
    end
  end
end
