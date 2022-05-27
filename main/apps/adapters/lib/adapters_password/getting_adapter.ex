defmodule Adapters.AdaptersPassword.GettingAdapter do
  alias Core.CoreDomains.Domains.Password
  alias Core.CoreDomains.Domains.Password.ValueObjects.Email
  alias Core.CoreDomains.Domains.Password.ValueObjects.Created
  alias Core.CoreDomains.Domains.Password.ValueObjects.ConfirmingCode
  alias Core.CoreDomains.Domains.Password.ValueObjects.Confirmed
  alias Core.CoreDomains.Domains.Password.ValueObjects.Password, as: ValuePassword
  alias Core.CoreDomains.Common.ValueObjects.Id

  alias Core.CoreDomains.Domains.Password.Ports.GettingPort

  alias Core.CoreDomains.Domains.Password.Dtos.ImpossibleGetError
  alias Core.CoreDomains.Domains.Password.Dtos.MapToDomainError
  alias Core.CoreDomains.Domains.Password.Dtos.NotFoundError

  @behaviour GettingPort

  @spec get(binary) :: GettingPort.ok() | GettingPort.error()
  def get(id) when is_binary(id) do
    case UUID.info(id) do
      {:error, _}-> {:error, ImpossibleGetError.new()}
      {:ok, _} ->
        case Node.connect(:password_postgres_service@localhost) do
          :false -> {:error, ImpossibleGetError.new()}
          :ignored -> {:error, ImpossibleGetError.new()}
          :true ->
            case Task.Supervisor.async({Passwords.Repo.TaskSupervisor, :password_postgres_service@localhost}, PasswordPostgresService, :get, [id]) |> Task.await() do
              {:ok, password} -> map_to_domain(password)
              {:ok, password, code} -> map_to_domain_with_code(password, code)
              {:error, _} -> {:error, NotFoundError.new()}
            end
        end
    end
  end

  def get(_) do
    {:error, ImpossibleGetError.new()}
  end

  defp map_to_domain(%{
    confirmed: confirmed,
    created: created,
    email: email,
    id: id,
    password: password
  }) do
    {
      :ok,
      %Password{
        confirmed: %Confirmed{value: confirmed},
        email: %Email{value: email},
        id: %Id{value: id},
        password: %ValuePassword{value: password},
        created: %Created{value: created}
      }
    }
  end

  defp map_to_domain(_) do
    {:error, MapToDomainError.new()}
  end

  defp map_to_domain_with_code(%{
    confirmed: confirmed,
    created: created,
    email: email,
    id: id,
    password: password
  }, %{code: code}) do
    {
      :ok,
      %Password{
        confirmed: %Confirmed{value: confirmed},
        confirmed_code: %ConfirmingCode{value: code},
        email: %Email{value: email},
        id: %Id{value: id},
        password: %ValuePassword{value: password},
        created: %Created{value: created}
      }
    }
  end

  defp map_to_domain_with_code(_,_) do
    {:error, MapToDomainError.new()}
  end
end
