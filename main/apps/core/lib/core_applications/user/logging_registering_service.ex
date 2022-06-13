defmodule Core.CoreApplications.User.LoggingRegisteringService do
  require Logger

  alias Core.CoreApplications.User.RegisteringService

  alias Core.CoreDomains.Domains.User.UseCases.Registering, as: RegisteringUseCase
  alias Core.CoreDomains.Domains.User.Ports.CreatingPort, as: CreatingUserPort
  alias Core.CoreDomains.Domains.Password.Ports.CreatingPort, as: CreatingPasswordPort
  alias Core.CoreDomains.Domains.Password.Ports.GettingConfirmingCodePort
  alias Core.CoreDomains.Common.Ports.Notifying

  alias Core.CoreDomains.Domains.User.Commands.RegisteringCommand

  alias Core.CoreApplications.LoggingHandler

  use LoggingHandler,
    command: "RegisteringCommand",
    remote_node: Application.get_env(:core, :user_logger_service)[:remote_node],
    remote_supervisor: Application.get_env(:core, :user_logger_service)[:remote_supervisor],
    remote_module: Application.get_env(:core, :user_logger_service)[:remote_module]

  @spec register(
    RegisteringCommand.t(),
    GettingConfirmingCodePort.t(),
    CreatingUserPort.t(),
    CreatingPasswordPort.t(),
    Notifying.t(),
    Notifying.t()
  ) :: RegisteringUseCase.ok() | RegisteringUseCase.error()
  def register(command, getting_confirming_port, creating_user_port, creating_password_port, notifying_port, admin_notifying_port) do
    case RegisteringService.register(command, getting_confirming_port, creating_user_port, creating_password_port, notifying_port) do
      {:error, dto} ->
        command = hidden_values(command)
        handler_error(command, dto, admin_notifying_port)
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
end
