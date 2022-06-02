defmodule Core.CoreApplications.Password.LoggingConfirmingService do
  alias Jason, as: JSON

  alias Core.CoreApplications.Password.Logger

  alias Core.CoreApplications.Password.ConfirmingService

  alias Core.CoreDomains.Domains.Password.UseCases.Confirming, as: ConfirmingPasswordUseCase

  alias Core.CoreDomains.Domains.Password.Commands.ConfirmCommand

  alias Core.CoreDomains.Domains.Password.Ports.GettingPort
  alias Core.CoreDomains.Domains.Password.Ports.ConfirmingPort
  alias Core.CoreDomains.Common.Ports.Notifying

  alias Core.CoreDomains.Domains.Password.Dtos.ImpossibleConfirmError
  alias Core.CoreDomains.Domains.Password.Dtos.ImpossibleGetError

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
        handler_error(admin_notifying_port, command, dto)
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

  defp handle_success(command) do
    case JSON.encode(Map.from_struct(command)) do
      {:ok, json} -> Logger.info("Node - #{node()}. ConfirmCommand - #{json}. Ok.")
      {:error, e} -> Logger.error("#{node()} #{e}. Ok.")
    end
  end

  defp handler_error(admin_notifying_port, command, %ImpossibleConfirmError{message: message}) do
    case JSON.encode(Map.from_struct(command)) do
      {:ok, json} ->
        Logger.error("Node - #{node()}. Remote Node - #{Application.get_env(:adapters_password, :remote_node)}. ConfirmCommand - #{json}. Error - #{message}")
        admin_notifying_port.notify("@MyComapnyDev", "Node - #{node()}. Remote Node - #{Application.get_env(:adapters_password, :remote_node)}. ConfirmCommand - #{json}. Error - #{message}")
      {:error, _} ->
        Logger.error("Node - #{node()}. Remote Node - #{Application.get_env(:adapters_password, :remote_node)}. Error - #{message}")
        admin_notifying_port.notify("@MyComapnyDev", "Node - #{node()}. Remote Node - #{Application.get_env(:adapters_password, :remote_node)}. Error - #{message}")
    end
  end

  defp handler_error(admin_notifying_port, command, %ImpossibleGetError{message: message}) do
    case JSON.encode(Map.from_struct(command)) do
      {:ok, json} ->
        Logger.error("Node - #{node()}. Remote Node - #{Application.get_env(:adapters_password, :remote_node)}. ConfirmCommand - #{json}. Error - #{message}")
        admin_notifying_port.notify("@MyComapnyDev", "Node - #{node()}. Remote Node - #{Application.get_env(:adapters_password, :remote_node)}. ConfirmCommand - #{json}. Error - #{message}")
      {:error, _} ->
        Logger.error("Node - #{node()}. Remote Node - #{Application.get_env(:adapters_password, :remote_node)}. Error - #{message}")
        admin_notifying_port.notify("@MyComapnyDev", "Node - #{node()}. Remote Node - #{Application.get_env(:adapters_password, :remote_node)}. Error - #{message}")
    end
  end

  defp handler_error(_, command, some_error_dto) do
    case JSON.encode(Map.from_struct(command)) do
      {:ok, json} ->
        Logger.info("Node - #{node()}. ConfirmCommand - #{json}. Error - #{some_error_dto.message}")
      {:error, _} ->
        Logger.error("Node - #{node()}. Error - #{some_error_dto.message}")
    end
  end
end
