defmodule Adapters.AdaptersUserPassword.GettingByEmailAdapter do
  alias Core.CoreDomains.Domains.Password.Ports.GettingPort

  alias Core.CoreDomains.Common.Dtos.ImpossibleGetError
  alias Core.CoreDomains.Common.Dtos.NotFoundError

  alias Adapters.AdaptersPassword.Mapper

  @behaviour GettingPort

  @spec get(binary) :: GettingPort.ok() | GettingPort.error()
  def get(email) when is_binary(email) do
    case Node.connect(Application.get_env(:adapters, :password_postgres_service)[:remote_node]) do
      :false -> {:error, ImpossibleCallError.new("Postgres user password service unavailable. Remote node - #{Application.get_env(:adapters, :password_postgres_service)[:remote_node]}")}
      :ignored -> {:error, ImpossibleCallError.new("Postgres user password service unavailable. Remote node - #{Application.get_env(:adapters, :password_postgres_service)[:remote_node]}")}
      :true ->
        case generate_task(email) |> Task.await() do
          {:ok, password} -> Mapper.map_to_domain(password)
          {:error, _} -> {:error, NotFoundError.new("Email not found")}
        end
    end
  end

  def get(_) do
    {:error, ImpossibleGetError.new("Impossible get user password from database for invalid data")}
  end

  defp generate_task(email) do
    Task.Supervisor.async(
      Application.get_env(:adapters, :password_postgres_service)[:remote_supervisor],
      Application.get_env(:adapters, :password_postgres_service)[:remote_module],
      :get_by_email,
      [email]
    )
  end
end
