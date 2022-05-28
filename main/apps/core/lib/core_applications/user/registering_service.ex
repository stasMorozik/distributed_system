defmodule Core.CoreApplications.User.RegisteringService do
  alias Core.CoreDomains.Domains.User.UseCases.Registering, as: RegisteringUseCase
  alias Core.CoreDomains.Domains.User.Ports.CreatingPort, as: CreatingUserPort
  alias Core.CoreDomains.Domains.Password.Ports.CreatingPort, as: CreatingPasswordPort
  alias Core.CoreDomains.Common.Ports.Notifying

  alias Core.CoreDomains.Domains.User.Commands.RegisteringCommand

  alias Core.CoreDomains.Domains.User
  alias Core.CoreDomains.Domains.Password

  @behaviour RegisteringUseCase

  @spec register(
    RegisteringCommand.t(),
    CreatingUserPort.t(),
    CreatingPasswordPort.t(),
    Notifying.t()
  ) :: RegisteringUseCase.ok() | RegisteringUseCase.error()
  def register(command, creating_user_port, creating_password_port, notifying_port) do
    case Password.create(command.email, command.password) do
      {:error, dto} -> {:error, dto}
      {:ok, password} ->
        case User.create(password, command.name) do
          {:error, dto} -> {:error, dto}
          {:ok, user} ->
            case creating_password_port.create(password) do
              {:error, dto} -> {:error, dto}
              {:ok, created_password} ->
                case creating_user_port.create(user) do
                  {:error, dto} -> {:error, dto}
                  {:ok, created_user} ->
                    notifying_port.notify("Hello #{created_user.name} you have to confirm your password by this code #{created_password.confirmed_code.value}.")
                    created_user
                end
            end
        end
    end
  end

end
