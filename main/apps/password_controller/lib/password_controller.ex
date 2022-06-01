defmodule PasswordController do
  @moduledoc """

  """
  alias Core.CoreApplications.Password.LoggingChangingEmailService
  alias Core.CoreApplications.Password.LoggingChangingPasswordService
  alias Core.CoreApplications.Password.LoggingConfirmingService

  alias Core.CoreDomains.Domains.Password
  alias Core.CoreDomains.Domains.Password.ValueObjects.Email
  alias Core.CoreDomains.Domains.Password.ValueObjects.ConfirmingCode
  alias Core.CoreDomains.Domains.Password.ValueObjects.Confirmed
  alias Core.CoreDomains.Domains.Password.ValueObjects.Password, as: ValuePassword
  alias Core.CoreDomains.Common.ValueObjects.Id
  alias Core.CoreDomains.Common.ValueObjects.Created

  alias Core.CoreDomains.Domains.Password.Commands.ChangeEmailCommand
  alias Core.CoreDomains.Domains.Password.Commands.ChangePasswordCommand
  alias alias Core.CoreDomains.Domains.Password.Commands.ConfirmCommand

  alias Adapters.AdaptersPassword.GettingAdapter
  alias Adapters.AdaptersPassword.ChangingEmailAdapter
  alias Adapters.AdaptersPassword.ChangingPasswordAdapter
  alias Adapters.AdaptersPassword.GettingByEmailAdapter
  alias Adapters.AdaptersPassword.ConfirmingAdapter
  alias Adapters.AdaptersCommon.NotifyingTelegramAdapter

  @doc """

  """
  def change_email(id, password, new_email) do
    case LoggingChangingEmailService.change(
      ChangeEmailCommand.new(id, password, new_email),
      GettingAdapter,
      ChangingEmailAdapter,
      NotifyingTelegramAdapter
    ) do
      {:ok, password} -> map_ok_from_domain(password)
      {:error, error} -> map_error_from_domain(error)
      _ -> {:error, %{message: "Error mapping password from domain"}}
    end
  end

  @doc """

  """
  def change_password(id, password, new_password) do
    case LoggingChangingPasswordService.change(
      ChangePasswordCommand.new(id, password, new_password),
      GettingAdapter,
      ChangingPasswordAdapter,
      NotifyingTelegramAdapter
    ) do
      {:ok, password} -> map_ok_from_domain(password)
      {:error, error} -> map_error_from_domain(error)
      _ -> {:error, %{message: "Error mapping password from domain"}}
    end
  end

  @doc """

  """
  def confirm(email, password, code) do
    case LoggingConfirmingService.confirm(
      ConfirmCommand.new(email, password, code),
      GettingByEmailAdapter,
      ConfirmingAdapter,
      NotifyingTelegramAdapter
    ) do
      {:ok, password} -> map_ok_from_domain(password)
      {:error, error} -> map_error_from_domain(error)
      _ -> {:error, %{message: "Error mapping password from domain"}}
    end
  end

  defp map_ok_from_domain(%Password{
    confirmed: %Confirmed{value: confirmed},
    confirmed_code: %ConfirmingCode{value: confirmed_code},
    email: %Email{value: email},
    id: %Id{value: id},
    password: %ValuePassword{value: _},
    created: %Created{value: created}
  }) do
    %{
      confirmed: confirmed,
      confirmed_code: confirmed_code,
      email: email,
      id: id,
      created: created
    }
  end

  defp map_ok_from_domain(%Password{
    confirmed: %Confirmed{value: confirmed},
    confirmed_code: nil,
    email: %Email{value: email},
    id: %Id{value: id},
    password: %ValuePassword{value: _},
    created: %Created{value: created}
  }) do
    {:ok, %{
      confirmed: confirmed,
      email: email,
      id: id,
      created: created
    }}
  end

  defp map_ok_from_domain(_) do
    {:error, %{message: "Error mapping password from domain"}}
  end

  defp map_error_from_domain(error) do
    {:error, %{message: error.message}}
  end
end
