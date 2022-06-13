defmodule Adapters.AdaptersUserPassword.GettingAdapter do
  alias Core.CoreDomains.Domains.Password.Ports.GettingPort

  alias Core.CoreDomains.Common.Dtos.IdIsInvalidError
  alias Core.CoreDomains.Common.Dtos.NotFoundError

  alias Adapters.AdaptersPassword.Mapper

  @behaviour GettingPort

  @spec get(binary) :: GettingPort.ok() | GettingPort.error()
  def get(id) when is_binary(id) do
    case UUID.info(id) do
      {:error, _}-> {:error, IdIsInvalidError.new()}
      {:ok, _} ->
        case Node.connect(Application.get_env(:adapters, :password_postgres_service)[:remote_node]) do
          :false -> {:error, ImpossibleCallError.new("Postgres user password service unavailable. Remote node - #{Application.get_env(:adapters, :password_postgres_service)[:remote_node]}")}
          :ignored -> {:error, ImpossibleCallError.new("Postgres user password service unavailable. Remote node - #{Application.get_env(:adapters, :password_postgres_service)[:remote_node]}")}
          :true ->
            case generate_task(id) |> Task.await() do
              {:ok, password} -> Mapper.map_to_domain(password)
              {:error, _} -> {:error, NotFoundError.new("Email not found")}
            end
        end
    end
  end

  def get(_) do
    {:error, IdIsInvalidError.new()}
  end

  defp generate_task(id) do
    Task.Supervisor.async(
      Application.get_env(:adapters, :password_postgres_service)[:remote_supervisor],
      Application.get_env(:adapters, :password_postgres_service)[:remote_module],
      :get,
      [id]
    )
  end
end
