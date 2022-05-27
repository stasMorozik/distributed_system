defmodule Core.CoreApplications.Password.ChangingEmailService do
  alias Core.CoreDomains.Domains.Password.UseCases.ChangingEmail, as: ChangingEmailUseCase

  alias Core.CoreDomains.Domains.Password

  alias Core.CoreDomains.Domains.Password.Commands.ChangeEmailCommand

  alias Core.CoreDomains.Domains.Password.Ports.GettingPort
  alias Core.CoreDomains.Domains.Password.Ports.ChangingEmailPort

  @behaviour ChangingEmailUseCase

  @spec change(
    ChangeEmailCommand.t(),
    GettingPort.t(),
    ChangingEmailPort.t()
  ) :: ChangingEmailUseCase.ok() | ChangingEmailUseCase.error()
  def change(command, getting_port, changing_email_port) do
    case getting_port.get(command.id) do
      {:error, dto} -> {:error, dto}
      {:ok, password} ->
        case Password.change_email(password, command.password, command.new_email) do
          {:error, dto} -> {:error, dto}
          {:ok, changed_password} -> changing_email_port.change(changed_password)
        end
    end
  end
end
