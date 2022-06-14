defmodule Core.CoreApplications.Password.ConfirmingEmailService do
  alias Core.CoreDomains.Domains.Password.UseCases.ConfirmingEmail, as: ConfirmingEmailUseCase

  alias Core.CoreDomains.Domains.Password.Ports.CreatingConfirmingCodePort

  alias Core.CoreDomains.Domains.Password.Commands.ConfirmingEmailCommand

  alias Core.CoreDomains.Common.Ports.Notifying

  alias Core.CoreDomains.Domains.Password

  @behaviour ConfirmingEmailUseCase

  @spec confirm(ConfirmingEmailCommand.t(), CreatingConfirmingCodePort.t(), Notifying.t()) :: ConfirmingEmailUseCase.error() | ConfirmingEmailUseCase.ok()
  def confirm(command, creating_confirming_code_port, notifying_port) do
    case Password.create_code(command.email) do
      {:error, dto} -> {:error, dto}
      {:ok, created_code} ->
        case creating_confirming_code_port.create(created_code) do
          {:error, dto} -> {:error, dto}
          {:ok, _} ->
            notifying_port.notify(command.email, "Confrim email address", "Your confirm code #{created_code.code}.")
            {:ok, created_code}
        end
    end
  end
end
