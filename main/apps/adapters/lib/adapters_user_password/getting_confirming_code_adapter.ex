defmodule Adapters.AdaptersUserPassword.GettingConfirmingCodeAdapter do
  alias Core.CoreDomains.Domains.Password.Ports.GettingConfirmingCodePort

  alias Core.CoreDomains.Common.Dtos.ImpossibleCallError
  alias Core.CoreDomains.Common.Dtos.ImpossibleGetError
  alias Core.CoreDomains.Common.Dtos.NotFoundError

  alias Adapters.AdaptersUserPassword.Mapper

  @behaviour GettingConfirmingCodePort

  @spec get(binary) :: GettingConfirmingCodePort.ok() | GettingConfirmingCodePort.error()
  def get(email) when is_binary(email) do
    case Node.connect(Application.get_env(:adapters, :user_password_postgres_service)[:remote_node]) do
      :false -> {:error, ImpossibleCallError.new("Postgres user password service unavailable. Remote node - #{Application.get_env(:adapters, :user_password_postgres_service)[:remote_node]}")}
      :ignored -> {:error, ImpossibleCallError.new("Postgres user password service unavailable. Remote node - #{Application.get_env(:adapters, :user_password_postgres_service)[:remote_node]}")}
      :true ->
        case generate_task(email) |> Task.await() do
          {:error, _} -> {:error, NotFoundError.new("Confirming code not found")}
          {:ok, confirming_code} -> Mapper.map_to_domain(confirming_code)
        end
    end
  end

  def get(_) do
    {:error, ImpossibleGetError.new("Impossible get confirming code from database for invalid data")}
  end

  defp generate_task(email) do
    Task.Supervisor.async(
      Application.get_env(:adapters, :user_password_postgres_service)[:remote_supervisor],
      Application.get_env(:adapters, :user_password_postgres_service)[:remote_module],
      :get_confirming_code,
      [email]
    )
  end
end
