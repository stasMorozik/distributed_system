defmodule Adapters.AdaptersPassword.GettingAdapter do
  alias Core.CoreDomains.Domains.Password.Ports.GettingPort

  alias Core.CoreDomains.Domains.Password.Dtos.ImpossibleGetError
  alias Core.CoreDomains.Domains.Password.Dtos.NotFoundError
  alias Core.CoreDomains.Common.Dtos.IdIsInvalidError

  alias Adapters.AdaptersPassword.Mapper

  @behaviour GettingPort

  @spec get(binary) :: GettingPort.ok() | GettingPort.error()
  def get(id) when is_binary(id) do
    case UUID.info(id) do
      {:error, _}-> {:error, IdIsInvalidError.new()}
      {:ok, _} ->
        case Node.connect(:password_postgres_service@localhost) do
          :false -> {:error, ImpossibleGetError.new("Postgres password service unavailable")}
          :ignored -> {:error, ImpossibleGetError.new("Postgres password service unavailable")}
          :true ->
            case generate_task(id) |> Task.await() do
              {:ok, password} -> Mapper.map_to_domain(password)
              {:ok, password, code} -> Mapper.map_to_domain_with_code(password, code)
              {:error, _} -> {:error, NotFoundError.new()}
            end
        end
    end
  end

  def get(_) do
    {:error, ImpossibleGetError.new("Impossible get password from database for invalid data")}
  end

  defp generate_task(id) do
    Task.Supervisor.async(
      {Passwords.Repo.TaskSupervisor,
      :password_postgres_service@localhost},
      PasswordPostgresService,
      :get,
      [id]
    )
  end
end
