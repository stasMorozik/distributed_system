defmodule Core.CoreApplications.User.ChangingEmailService do
  alias Core.CoreDomains.Domains.User.UseCases.ChangingEmail, as: ChangingEmailUseCase

  alias Core.CoreDomains.Domains.User.Commands.ChangingEmailCommand

  alias Core.CoreDomains.Domains.Password.Ports.GettingPort
  alias Core.CoreDomains.Domains.Password.Ports.GettingConfirmingCodePort
  alias Core.CoreDomains.Domains.Password.Ports.ChangingEmailPort

  alias Core.CoreDomains.Domains.Token
  alias Core.CoreDomains.Domains.Password

  @behaviour ChangingEmailUseCase

  @spec change(
    ChangingEmailCommand.t(),
    GettingPort.t(),
    GettingConfirmingCodePort.t(),
    ChangingEmailPort.t()
  ) :: ChangingEmailUseCase.error() | ChangingEmailUseCase.ok()
  def change(command, getting_password_port, getting_confirming_code_port, changing_email_port) do
    case Token.verify_token(command.token, Application.get_env(:joken, :user_signer)) do
      {:error, dto} -> {:error, dto}
      {:ok, id} ->
        case getting_password_port.get(id) do
          {:error, dto} -> {:error, dto}
          {:ok, password} ->
            case getting_confirming_code_port.get(command.new_email) do
              {:error, dto} -> {:error, dto}
              {:ok, confirming_code} ->
                case Password.change_email(password, confirming_code, command.new_email, command.code) do
                  {:error, dto} -> {:error, dto}
                  {:ok, updated_password} ->
                    case changing_email_port.change(updated_password) do
                      {:error, dto} -> {:error, dto}
                      {:ok, _} -> {:ok, updated_password}
                    end
                end
            end
        end
    end
  end
end
