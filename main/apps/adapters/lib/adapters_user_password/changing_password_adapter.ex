defmodule Adapters.AdaptersUserPassword.ChangingPasswordAdapter do
  alias Core.CoreDomains.Domains.Password
  alias Core.CoreDomains.Domains.Password.ValueObjects.Password, as: ValuePassword
  alias Core.CoreDomains.Common.ValueObjects.Id

  alias Core.CoreDomains.Domains.Password.Ports.ChangingPasswordPort

  alias Core.CoreDomains.Domains.Password

  alias Core.CoreDomains.Common.Dtos.ImpossibleCallError
  alias Core.CoreDomains.Common.Dtos.IdIsInvalidError
  alias Core.CoreDomains.Common.Dtos.NotFoundError
  alias Core.CoreDomains.Common.Dtos.ImpossibleUpdateError

  @behaviour ChangingPasswordPort

  @spec change(Password.t()) :: ChangingPasswordPort.ok() | ChangingPasswordPort.error()
  def change(%Password{
    confirmed: confirmed,
    email: email,
    id: %Id{value: id},
    password: %ValuePassword{value: password},
    created: created
  }) when is_binary(id) and is_binary(password) do
    case UUID.info(id) do
      {:error, _} -> {:error, IdIsInvalidError.new()}
      {:ok, _} ->
        case Node.connect(Application.get_env(:adapters, :password_postgres_service)[:remote_node]) do
          :false -> {:error, ImpossibleCallError.new("Postgres user password service unavailable. Remote node - #{Application.get_env(:adapters, :password_postgres_service)[:remote_node]}")}
          :ignored -> {:error, ImpossibleCallError.new("Postgres user password service unavailable. Remote node - #{Application.get_env(:adapters, :password_postgres_service)[:remote_node]}")}
          :true ->
            case generate_task(id, password) |> Task.await() do
              {:ok, _} -> {:ok, %Password{
                confirmed: confirmed,
                email: email,
                id: %Id{value: id},
                password: %ValuePassword{value: password},
                created: created
              }}
              {:error, _} -> {:error, NotFoundError.new("Email not found")}
            end
        end
    end
  end

  def change(_) do
    {:error, ImpossibleUpdateError.new("Impossible user change password into database for invalid data")}
  end

  defp generate_task(id, password) do
    Task.Supervisor.async(
      Application.get_env(:adapters, :password_postgres_service)[:remote_supervisor],
      Application.get_env(:adapters, :password_postgres_service)[:remote_module],
      :change_password,
      [id, password]
    )
  end
end
