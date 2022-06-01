defmodule Core.CoreApplications.Password.LoggingChangingEmailService do
  alias Core.CoreApplications.Password.Logger

  alias Core.CoreDomains.Domains.Password.UseCases.ChangingEmail, as: ChangingEmailUseCase

  alias Core.CoreApplications.Password.ChangingEmailService

  alias Core.CoreDomains.Domains.Password.Commands.ChangeEmailCommand

  alias Core.CoreDomains.Domains.Password.Ports.GettingPort
  alias Core.CoreDomains.Domains.Password.Ports.ChangingEmailPort
  alias Core.CoreDomains.Common.Ports.Notifying

  alias Core.CoreDomains.Domains.Password.Dtos.ImpossibleChangeEmailError
  alias alias Core.CoreDomains.Domains.Password.Dtos.ImpossibleGetError

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
        handler_error(admin_notifying_port, command, dto)
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

  defp handle_success(command) do
    case JSON.encode(Map.from_struct(command)) do
      {:ok, json} -> Logger.info("Node - #{node()}. ChangeEmailCommand - #{json}. Ok.")
      {:error, e} -> Logger.error("#{node()} #{e}. Ok.")
    end
  end

  defp handler_error(admin_notifying_port, command, %ImpossibleChangeEmailError{message: message}) do
    case JSON.encode(Map.from_struct(command)) do
      {:ok, json} ->
        Logger.error("Node - #{node()}. Remote Node - #{Application.get_env(:adapters_password, :remote_node)}. ChangeEmailCommand - #{json}. Error - #{message}")
        admin_notifying_port.notify("@MyComapnyDev", "Node - #{node()}. Remote Node - #{Application.get_env(:adapters_password, :remote_node)}. ChangeEmailCommand - #{json}. Error - #{message}")
      {:error, _} ->
        Logger.error("Node - #{node()}. Remote Node - #{Application.get_env(:adapters_password, :remote_node)}. Error - #{message}")
        admin_notifying_port.notify("@MyComapnyDev", "Node - #{node()}. Remote Node - #{Application.get_env(:adapters_password, :remote_node)}. Error - #{message}")
    end
  end

  defp handler_error(admin_notifying_port, command, %ImpossibleGetError{message: message}) do
    case JSON.encode(Map.from_struct(command)) do
      {:ok, json} ->
        Logger.error("Node - #{node()}. Remote Node - #{Application.get_env(:adapters_password, :remote_node)}. ChangeEmailCommand - #{json}. Error - #{message}")
        admin_notifying_port.notify("@MyComapnyDev", "Node - #{node()}. Remote Node - #{Application.get_env(:adapters_password, :remote_node)}. ChangeEmailCommand - #{json}. Error - #{message}")
      {:error, _} ->
        Logger.error("Node - #{node()}. Remote Node - #{Application.get_env(:adapters_password, :remote_node)}. Error - #{message}")
        admin_notifying_port.notify("@MyComapnyDev", "Node - #{node()}. Remote Node - #{Application.get_env(:adapters_password, :remote_node)}. Error - #{message}")
    end
  end

  defp handler_error(_, command, some_error_dto) do
    case JSON.encode(Map.from_struct(command)) do
      {:ok, json} ->
        Logger.info("Node - #{node()}. ChangeEmailCommand - #{json}. Error - #{some_error_dto.message}")
      {:error, _} ->
        Logger.error("Node - #{node()}. Error - #{some_error_dto.message}")
    end
  end
end
