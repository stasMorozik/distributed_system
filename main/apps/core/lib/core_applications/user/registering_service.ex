defmodule Core.CoreApplications.User.RegisteringService do
  alias Core.CoreDomains.Domains.User.UseCases.Registering, as: RegisteringUseCase
  alias Core.CoreDomains.Domains.User.Ports.CreatingPort, as: CreatingUserPort
  alias Core.CoreDomains.Domains.Password.Ports.CreatingPort, as: CreatingPasswordPort
  alias Core.CoreDomains.Domains.Password.Ports.GettingConfirmingCodePort
  alias Core.CoreDomains.Common.Ports.Notifying

  alias Core.CoreDomains.Domains.User.Commands.RegisteringCommand

  alias Core.CoreDomains.Domains.User
  alias Core.CoreDomains.Domains.Password

  @behaviour RegisteringUseCase

  @spec register(
    RegisteringCommand.t(),
    GettingConfirmingCodePort.t(),
    CreatingUserPort.t(),
    CreatingPasswordPort.t(),
    Notifying.t()
  ) :: RegisteringUseCase.ok() | RegisteringUseCase.error()
  def register(command, getting_confirming_port, creating_user_port, creating_password_port, notifying_port) do
    case getting_confirming_port.get(command.email) do
      {:error, dto} -> {:error, dto}
      {:ok, confirming_code} ->
        case Password.create(command.email, command.password, command.code, confirming_code) do
          {:error, dto} -> {:error, dto}
          {:ok, created_password} ->
            case User.create(created_password, command.name) do
              {:error, dto} -> {:error, dto}
              {:ok, created_user} ->
                case creating_password_port.create(created_password) do
                  {:error, dto} -> {:error, dto}
                  {:ok, _} ->
                    case creating_user_port.create(created_user) do
                      {:error, dto} -> {:error, dto}
                      {:ok, inserted_user} ->
                        notifying_port.notify(command.email, "Greetings", "Hello #{command.name} enjoying joining!")
                        {:ok, inserted_user}
                    end
                end
            end
        end
    end
  end
end
