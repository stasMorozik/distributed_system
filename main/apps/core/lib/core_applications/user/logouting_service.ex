defmodule Core.CoreApplications.User.LogoutingService do
  alias Core.CoreDomains.Domains.User.UseCases.Logouting, as: LogoutingUseCase

  alias Core.CoreDomains.Domains.User.Commands.LogoutCommand

  alias Core.CoreDomains.Domains.Token

  @behaviour LogoutingUseCase

  @spec logout(LogoutCommand.t()) :: LogoutingUseCase.error() | LogoutingUseCase.ok()
  def logout(command) do
    case Token.verify_token(command.token, Application.get_env(:joken, :user_signer)) do
      {:error, dto} -> {:error, dto}
      {:ok, some} -> {:ok, some}
    end
  end
end
