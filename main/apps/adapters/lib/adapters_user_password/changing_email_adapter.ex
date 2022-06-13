defmodule Adapters.AdaptersUserPassword.ChangingEmailAdapter do
  alias Core.CoreDomains.Domains.Password
  alias Core.CoreDomains.Domains.Password.ValueObjects.Email
  alias Core.CoreDomains.Common.ValueObjects.Id

  alias Core.CoreDomains.Domains.Password.Ports.ChangingEmailPort

  alias Core.CoreDomains.Common.Dtos.AlreadyExistsError
  alias Core.CoreDomains.Common.Dtos.ImpossibleUpdateError
  alias Core.CoreDomains.Common.Dtos.IdIsInvalidError
  alias Core.CoreDomains.Common.Dtos.ImpossibleCallError

  @behaviour ChangingEmailPort

  @spec change(Password.t()) :: ChangingEmailPort.ok() | ChangingEmailPort.error()
  def change(%Password{
    confirmed: confirmed,
    email: %Email{value: email},
    id: %Id{value: id},
    password: password,
    created: created
  }) when is_binary(email) and is_binary(id) do
    case UUID.info(id) do
      {:error, _} -> {:error, IdIsInvalidError.new()}
      {:ok, _} ->
        case Node.connect(Application.get_env(:adapters, :password_postgres_service)[:remote_node]) do
          :false -> {:error, ImpossibleCallError.new("Postgres user password service unavailable. Remote node - #{Application.get_env(:adapters, :password_postgres_service)[:remote_node]}")}
          :ignored -> {:error, ImpossibleCallError.new("Postgres user password service unavailable. Remote node - #{Application.get_env(:adapters, :password_postgres_service)[:remote_node]}")}
          :true ->
            case generate_task(id, email) |> Task.await() do
              {:ok, _} -> {:ok, %Password{
                confirmed: confirmed,
                email: %Email{value: email},
                id: %Id{value: id},
                password: password,
                created: created
              }}
              {:error, _} -> {:error, AlreadyExistsError.new("Email already exists")}
            end
        end
    end
  end

  def change(_) do
    {:error, ImpossibleUpdateError.new("Impossible user change email into database for invalid data")}
  end

  defp generate_task(id, email) do
    Task.Supervisor.async(
      Application.get_env(:adapters, :password_postgres_service)[:remote_supervisor],
      Application.get_env(:adapters, :password_postgres_service)[:remote_module],
      :change_email,
      [id, email]
    )
  end
end
