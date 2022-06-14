defmodule UserController do
  alias Core.CoreApplications.User.LoggingRegisteringService
  alias Core.CoreApplications.User.LoggingAuthenticatingService
  alias Core.CoreApplications.User.LoggingLogoutingService
  alias Core.CoreApplications.Password.LoggingConfirmingEmailService

  alias Core.CoreDomains.Domains.User

  alias Core.CoreDomains.Domains.User.Commands.RegisteringCommand
  alias Core.CoreDomains.Domains.User.Commands.AuthenticatingCommand
  alias Core.CoreDomains.Domains.User.Commands.LogoutCommand
  alias Core.CoreDomains.Domains.Password.Commands.ConfirmingEmailCommand

  alias Core.CoreDomains.Common.ValueObjects.Id
  alias Core.CoreDomains.Common.ValueObjects.Created
  alias Core.CoreDomains.Common.ValueObjects.Name
  alias Core.CoreDomains.Common.ValueObjects.Avatar
  alias Core.CoreDomains.Domains.Password.ValueObjects.ConfirmingCode

  alias Adapters.AdaptersUser.CreatingAdapter, as: CreatingUserAdapter
  alias Adapters.AdaptersUserPassword.CreatingAdapter, as: CreatingPasswordAdapter
  alias Adapters.AdaptersCommon.NotifyingMailerAdapter
  alias Adapters.AdaptersCommon.NotifyingTelegramAdapter
  alias Adapters.AdaptersUserPassword.GettingByEmailAdapter, as: GettingPasswordByEmailAdapter
  alias Adapters.AdaptersUserPassword.GettingConfirmingCodeAdapter
  alias Adapters.AdaptersUserPassword.CreatingConfirmingCodeAdapter

  def confrim_email(email) do
    case LoggingConfirmingEmailService.confirm(
      ConfirmingEmailCommand.new(email),
      CreatingConfirmingCodeAdapter,
      NotifyingMailerAdapter,
      NotifyingTelegramAdapter
    ) do
      {:error, error} -> map_error_from_domain(error)
      {:ok, _} -> {:ok, true}
      _ -> {:error, %{message: "Error mapping confirming code from domain"}}
    end
  end

  def register(email, password, name, code) do
    case LoggingRegisteringService.register(
      RegisteringCommand.new(email, password, name, code),
      GettingConfirmingCodeAdapter,
      CreatingUserAdapter,
      CreatingPasswordAdapter,
      NotifyingMailerAdapter,
      NotifyingTelegramAdapter
    ) do
      {:error, error} -> map_error_from_domain(error)
      {:ok, _} -> {:ok, true}
      _ -> {:error, %{message: "Error mapping user from domain"}}
    end
  end

  def authenticate(email, password) do
    case LoggingAuthenticatingService.authenticate(
      AuthenticatingCommand.new(email, password),
      GettingPasswordByEmailAdapter,
      NotifyingTelegramAdapter
    ) do
      {:ok, token} -> {:ok, token}
      {:error, error} -> map_error_from_domain(error)
      _ -> {:error, %{message: "Error mapping user from domain"}}
    end
  end

  def logout(token) do
    case LoggingLogoutingService.logout(
      LogoutCommand.new(token)
    ) do
      {:error, error} -> map_error_from_domain(error)
      {:ok, some} -> {:ok, some}
    end
  end

  defp map_ok_from_domain(%User{
    id: %Id{value: id},
    created: %Created{value: created},
    name: %Name{value: name},
    avatar: nil
  }) do
    {:ok, %{
      id: id,
      name: name,
      created: created,
      avatar: nil
    }}
  end

  defp map_ok_from_domain(%User{
    id: %Id{value: id},
    created: %Created{value: created},
    name: %Name{value: name},
    avatar: %Avatar{value: image}
  }) do
    {:ok, %{
      id: id,
      name: name,
      created: created,
      avatar: image
    }}
  end

  defp map_ok_from_domain(%ConfirmingCode{code: code, email: email}) do
    {:ok, %{
      code: code,
      email: email
    }}
  end

  defp map_ok_from_domain(_) do
    {:error, %{message: "Error mapping user from domain"}}
  end

  defp map_error_from_domain(error) do
    {:error, %{message: error.message}}
  end
end
