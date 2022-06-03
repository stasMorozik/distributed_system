defmodule Core.CoreApplications.Password.LoggingChangingPasswordService do
  alias Jason, as: JSON

  alias Core.CoreApplications.Password.Logger

  alias Core.CoreDomains.Domains.Password.UseCases.ChanginPassword, as: ChanginPasswordUseCase

  alias Core.CoreApplications.Password.ChangingPasswordService

  alias Core.CoreDomains.Domains.Password.Commands.ChangePasswordCommand

  alias Core.CoreDomains.Domains.Password.Ports.GettingPort
  alias Core.CoreDomains.Domains.Password.Ports.ChangingPasswordPort
  alias Core.CoreDomains.Common.Ports.Notifying

  alias Core.CoreDomains.Domains.Password.Dtos.ImpossibleChangeError
  alias Core.CoreDomains.Domains.Password.Dtos.ImpossibleGetError

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
        handler_error(admin_notifying_port, command, dto)
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

  defp handle_success(command) do
    case JSON.encode(Map.from_struct(command)) do
      {:ok, json} ->
        Logger.info("Node - #{node()}. ChangePasswordCommand - #{json}. Ok.")
      {:error, e} ->
        Logger.error("#{node()} #{e}. Ok.")
    end
  end

  defp handler_error(admin_notifying_port, command, %ImpossibleChangeError{message: message}) do
    case JSON.encode(Map.from_struct(command)) do
      {:ok, json} ->
        Logger.error("Node - #{node()}. Remote Node - #{Application.get_env(:adapters_password, :remote_node)}. ChangePasswordCommand - #{json}. Error - #{message}")
        admin_notifying_port.notify("@MyComapnyDev", "Error", "Node - #{node()}. Remote Node - #{Application.get_env(:adapters_password, :remote_node)}. ChangePasswordCommand - #{json}. Error - #{message}")
      {:error, _} ->
        Logger.error("Node - #{node()}. Remote Node - #{Application.get_env(:adapters_password, :remote_node)}. Error - #{message}")
        admin_notifying_port.notify("@MyComapnyDev", "Error", "Node - #{node()}. Remote Node - #{Application.get_env(:adapters_password, :remote_node)}. Error - #{message}")
    end
  end

  defp handler_error(admin_notifying_port, command, %ImpossibleGetError{message: message}) do
    case JSON.encode(Map.from_struct(command)) do
      {:ok, json} ->
        Logger.error("Node - #{node()}. Remote Node - #{Application.get_env(:adapters_password, :remote_node)}. ChangePasswordCommand - #{json}. Error - #{message}")
        admin_notifying_port.notify("@MyComapnyDev", "Error", "Node - #{node()}. Remote Node - #{Application.get_env(:adapters_password, :remote_node)}. ChangePasswordCommand - #{json}. Error - #{message}")
      {:error, _} ->
        Logger.error("Node - #{node()}. Remote Node - #{Application.get_env(:adapters_password, :remote_node)}. Error - #{message}")
        admin_notifying_port.notify("@MyComapnyDev", "Error", "Node - #{node()}. Remote Node - #{Application.get_env(:adapters_password, :remote_node)}. Error - #{message}")
    end
  end

  defp handler_error(_, command, some_error_dto) do
    case JSON.encode(Map.from_struct(command)) do
      {:ok, json} ->
        Logger.info("Node - #{node()}. ChangePasswordCommand - #{json}. Error - #{some_error_dto.message}")
      {:error, _} ->
        Logger.error("Node - #{node()}. Error - #{some_error_dto.message}")
    end
  end
end
