defmodule Adapters.AdaptersPassword.GettingByEmailAdapter do
  alias Core.CoreDomains.Domains.Password.Ports.GettingPort

  alias Core.CoreDomains.Domains.Password.Dtos.ImpossibleGetError
  alias Core.CoreDomains.Domains.Password.Dtos.NotFoundError

  alias Adapters.AdaptersPassword.Mapper

  @behaviour GettingPort

  @spec get(binary) :: GettingPort.ok() | GettingPort.error()
  def get(email) when is_binary(email) do
    case Node.connect(:password_postgres_service@localhost) do
      :false -> {:error, ImpossibleGetError.new()}
      :ignored -> {:error, ImpossibleGetError.new()}
      :true ->
        case generate_task(email) |> Task.await() do
          {:ok, password} -> Mapper.map_to_domain(password)
          {:ok, password, code} -> Mapper.map_to_domain_with_code(password, code)
          {:error, _} -> {:error, NotFoundError.new()}
        end
    end
  end

  def get(_) do
    {:error, ImpossibleGetError.new()}
  end

  defp generate_task(email) do
    Task.Supervisor.async(
      {Passwords.Repo.TaskSupervisor,
      :password_postgres_service@localhost},
      PasswordPostgresService,
      :get_by_email,
      [email]
    )
  end
end
