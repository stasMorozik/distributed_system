defmodule Core.CoreApplications.User.AuthenticatingService do
  alias Core.CoreDomains.Domains.User.UseCases.Authenticating, as: AuthenticatingUserUseCase

  alias Core.CoreDomains.Domains.Password.Ports.GettingPort

  alias Core.CoreDomains.Domains.Token
  alias Core.CoreDomains.Domains.Password

  alias Core.CoreDomains.Domains.User.Commands.AuthenticatingCommand

  @behaviour AuthenticatingUserUseCase

  @spec authenticate(AuthenticatingCommand.t(), GettingPort.t()) :: AuthenticatingUserUseCase.error() | AuthenticatingUserUseCase.ok()
  def authenticate(command, getting_password_port) do
    case getting_password_port.get(command.email) do
      {:error, dto} -> {:error, dto}
      {:ok, password} ->
        case Password.validate_password(password, command.password) do
          {:error, dto} -> {:error, dto}
          {:ok, validated_password} ->
            case Token.create(validated_password, Application.get_env(:joken, :user_signer)) do
              {:error, dto} -> {:error, dto}
              {:ok, token} -> {:ok, token}
            end
        end
    end
  end
end
