defmodule Adapters.AdaptersUserPassword.CreatingConfirmingCodeAdapter do
  alias Core.CoreDomains.Domains.Password.Ports.CreatingConfirmingCodePort

  alias Core.CoreDomains.Domains.Password.ValueObjects.ConfirmingCode

  alias Core.CoreDomains.Common.Dtos.ImpossibleCallError
  alias Core.CoreDomains.Common.Dtos.ImpossibleCreateError

  @behaviour CreatingConfirmingCodePort

  @spec create(ConfirmingCode.t()) :: CreatingConfirmingCodePort.ok() | CreatingConfirmingCodePort.error()
  def create(%ConfirmingCode{code: code, email: email}) when is_integer(code) and is_binary(email) do
    case Node.connect(Application.get_env(:adapters, :user_password_postgres_service)[:remote_node]) do
      :false -> {:error, ImpossibleCallError.new("Postgres user password service unavailable. Remote node - #{Application.get_env(:adapters, :user_password_postgres_service)[:remote_node]}")}
      :ignored -> {:error, ImpossibleCallError.new("Postgres user password service unavailable. Remote node - #{Application.get_env(:adapters, :user_password_postgres_service)[:remote_node]}")}
      :true ->
        code_map = %{
          email: email,
          code: code
        }
        case generate_task(code_map) |> Task.await() do
          {:ok, _} -> {:ok, %ConfirmingCode{code: code, email: email}}
        end
    end
  end

  def create(_) do
    {:error, ImpossibleCreateError.new("Impossible create confirming code into database for invalid data")}
  end

  defp generate_task(code_map) do
    Task.Supervisor.async(
      Application.get_env(:adapters, :user_password_postgres_service)[:remote_supervisor],
      Application.get_env(:adapters, :user_password_postgres_service)[:remote_module],
      :create_confirming_code,
      [code_map]
    )
  end
end
