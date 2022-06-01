defmodule Core.CoreApplications.User.LoggingRegisteringService do
  alias Core.CoreApplications.User.Logger

  alias Core.CoreApplications.User.RegisteringService

  alias Core.CoreDomains.Domains.User.UseCases.Registering, as: RegisteringUseCase
  alias Core.CoreDomains.Domains.User.Ports.CreatingPort, as: CreatingUserPort
  alias Core.CoreDomains.Domains.Password.Ports.CreatingPort, as: CreatingPasswordPort
  alias Core.CoreDomains.Common.Ports.Notifying

  alias Core.CoreDomains.Domains.User.Commands.RegisteringCommand

  alias Core.CoreDomains.Domains.Password.Dtos.ImpossibleCreateError, as: ImpossibleCreatePasswordError
  alias Core.CoreDomains.Domains.User.Dtos.ImpossibleCreateError, as: ImpossibleCreateUserError

  @spec register(
    RegisteringCommand.t(),
    CreatingUserPort.t(),
    CreatingPasswordPort.t(),
    Notifying.t(),
    Notifying.t()
  ) :: RegisteringUseCase.ok() | RegisteringUseCase.error()
  def register(command, creating_user_port, creating_password_port, notifying_port, admin_notifying_port) do
    case RegisteringService.register(command, creating_user_port, creating_password_port, notifying_port) do
      {:error, dto} ->
        command = hidden_values(command)
        handler_error(admin_notifying_port, command, dto)
        {:error, dto}
      {:ok, created_user} ->
        hidden_values(command) |> handle_success()
        {:ok, created_user}
    end
  end

  defp hidden_values(command) do
    %RegisteringCommand{
      email: command.email,
      name: command.name
    }
  end

  defp handle_success(command) do
    case JSON.encode(Map.from_struct(command)) do
      {:ok, json} -> Logger.info("Node - #{node()}. RegisteringCommand - #{json}. Ok.")
      {:error, e} -> Logger.error("#{node()} #{e}. Ok.")
    end
  end

  defp handler_error(admin_notifying_port, command, %ImpossibleCreateUserError{message: message}) do
    case JSON.encode(Map.from_struct(command)) do
      {:ok, json} ->
        Logger.error("Node - #{node()}. Remote Node - #{Application.get_env(:adapters_user, :remote_node)}. RegisteringCommand - #{json}. Error - #{message}")
        admin_notifying_port.notify("@MyComapnyDev", "Node - #{node()}. Remote Node - #{Application.get_env(:adapters_user, :remote_node)}. RegisteringCommand - #{json}. Error - #{message}")
      {:error, _} ->
        Logger.error("Node - #{node()}. Remote Node - #{Application.get_env(:adapters_user, :remote_node)}. Error - #{message}")
        admin_notifying_port.notify("@MyComapnyDev", "Node - #{node()}. Remote Node - #{Application.get_env(:adapters_user, :remote_node)}. Error - #{message}")
    end
  end

  defp handler_error(admin_notifying_port, command, %ImpossibleCreatePasswordError{message: message}) do
    case JSON.encode(Map.from_struct(command)) do
      {:ok, json} ->
        Logger.error("Node - #{node()}. Remote Node - #{Application.get_env(:adapters_user, :remote_node)}. RegisteringCommand - #{json}. Error - #{message}")
        admin_notifying_port.notify("@MyComapnyDev", "Node - #{node()}. Remote Node - #{Application.get_env(:adapters_user, :remote_node)}. RegisteringCommand - #{json}. Error - #{message}")
      {:error, _} ->
        Logger.error("Node - #{node()}. Remote Node - #{Application.get_env(:adapters_user, :remote_node)}. Error - #{message}")
        admin_notifying_port.notify("@MyComapnyDev", "Node - #{node()}. Remote Node - #{Application.get_env(:adapters_user, :remote_node)}. Error - #{message}")
    end
  end

  defp handler_error(_, command, some_error_dto) do
    case JSON.encode(Map.from_struct(command)) do
      {:ok, json} ->
        Logger.info("Node - #{node()}. RegisteringCommand - #{json}. Error - #{some_error_dto.message}")
      {:error, _} ->
        Logger.error("Node - #{node()}. Error - #{some_error_dto.message}")
    end
  end
end
