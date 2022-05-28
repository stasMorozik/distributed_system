defmodule Core.CoreApplications.Password.ChangingPasswordService do
  alias Core.CoreDomains.Domains.Password.UseCases.ChanginPassword, as: ChanginPasswordUseCase

  alias Core.CoreDomains.Domains.Password

  alias Core.CoreDomains.Domains.Password.Commands.ChangePasswordCommand

  alias Core.CoreDomains.Domains.Password.Ports.GettingPort
  alias Core.CoreDomains.Domains.Password.Ports.ChangingPasswordPort

  @behaviour ChanginPasswordUseCase

  @spec change(
    ChangePasswordCommand.t(),
    GettingPort.t(),
    ChangingPasswordPort.t()
  ) :: ChanginPasswordUseCase.ok() | ChanginPasswordUseCase.error()
  def change(command, getting_port, changing_password_port) do
    case getting_port.get(command.id) do
      {:error, dto} -> {:error, dto}
      {:ok, password} ->
        case Password.change_password(password, command.password, command.new_password) do
          {:error, dto} -> {:error, dto}
          {:ok, changed_password} -> changing_password_port.change(changed_password)
        end
    end
  end
end
