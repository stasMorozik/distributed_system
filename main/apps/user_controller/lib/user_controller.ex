defmodule UserController do
  alias Core.CoreApplications.User.RegisteringService

  alias Core.CoreDomains.Domains.User

  alias Core.CoreDomains.Domains.User.Commands.RegisteringCommand

  alias Core.CoreDomains.Common.ValueObjects.Id
  alias Core.CoreDomains.Common.ValueObjects.Created
  alias Core.CoreDomains.Common.ValueObjects.Name

  alias Adapters.AdaptersUser.CreatingAdapter, as: CreatingUserAdapter
  alias Adapters.AdaptersPassword.CreatingAdapter, as: CreatingPasswordAdapter
  alias Adapters.AdaptersCommon.NotifyingMailerAdapter

  def register(email, password, name) do
    case RegisteringService.register(
      RegisteringCommand.new(email, password, name),
      CreatingUserAdapter,
      CreatingPasswordAdapter,
      NotifyingMailerAdapter
    ) do
      {:ok, password} -> map_ok_from_domain(password)
      {:error, error} -> map_error_from_domain(error)
      _ -> {:error, %{message: "Error mapping user from domain"}}
    end
  end

  defp map_ok_from_domain(%User{
    id: %Id{value: id},
    created: %Created{value: created},
    name: %Name{value: name},
  }) do
    {:ok, %{
      id: id,
      name: name,
      created: created
    }}
  end

  defp map_ok_from_domain(_) do
    {:error, %{message: "Error mapping user from domain"}}
  end

  defp map_error_from_domain(error) do
    {:error, %{message: error.message}}
  end
end
