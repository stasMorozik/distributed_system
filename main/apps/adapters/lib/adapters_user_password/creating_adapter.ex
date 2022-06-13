defmodule Adapters.AdaptersUserPassword.CreatingAdapter do
  alias Core.CoreDomains.Domains.Password.Ports.CreatingPort

  alias alias Core.CoreDomains.Domains.Password

  alias Core.CoreDomains.Domains.Password.ValueObjects.Email
  alias Core.CoreDomains.Domains.Password.ValueObjects.Confirmed
  alias Core.CoreDomains.Domains.Password.ValueObjects.Password, as: ValuePassword
  alias Core.CoreDomains.Common.ValueObjects.Id
  alias Core.CoreDomains.Common.ValueObjects.Created

  alias Core.CoreDomains.Common.Dtos.AlreadyExistsError
  alias Core.CoreDomains.Common.Dtos.IdIsInvalidError
  alias Core.CoreDomains.Common.Dtos.ImpossibleCallError
  alias Core.CoreDomains.Common.Dtos.ImpossibleCreateError

  @behaviour CreatingPort

  @spec create(Password.t()) :: CreatingPort.error() | CreatingPort.ok()
  def create(%Password{
    confirmed: %Confirmed{value: confirmed},
    email: %Email{value: email},
    id: %Id{value: id},
    password: %ValuePassword{value: password},
    created: %Created{value: created}
  }) when
    is_binary(id) and
    is_binary(email) and
    is_binary(password) and
    is_boolean(confirmed)  do
      case UUID.info(id) do
        {:error, _} -> {:error, IdIsInvalidError.new()}
        {:ok, _} ->
          case Node.connect(Application.get_env(:adapters, :user_password_postgres_service)[:remote_node]) do
            :false -> {:error, ImpossibleCallError.new("Postgres user password service unavailable. Remote node - #{Application.get_env(:adapters, :user_password_postgres_service)[:remote_node]}")}
            :ignored -> {:error, ImpossibleCallError.new("Postgres user password service unavailable. Remote node - #{Application.get_env(:adapters, :user_password_postgres_service)[:remote_node]}")}
            :true ->
              pswd_map = %{
                id: id,
                password: password,
                email: email,
                confirmed: confirmed,
                created: created
              }
              case generate_task(pswd_map) |> Task.await() do
                {:ok, _} -> {:ok, %Password{
                  confirmed: %Confirmed{value: confirmed},
                  email: %Email{value: email},
                  id: %Id{value: id},
                  password: %ValuePassword{value: password},
                  created: %Created{value: created}
                }}
                {:error, _} -> {:error, AlreadyExistsError.new("Email already exists")}
              end
          end
      end
  end

  def create(_) do
    {:error, ImpossibleCreateError.new("Impossible create user password into database for invalid data")}
  end

  defp generate_task(password_map) do
    Task.Supervisor.async(
      Application.get_env(:adapters, :user_password_postgres_service)[:remote_supervisor],
      Application.get_env(:adapters, :user_password_postgres_service)[:remote_module],
      :create,
      [password_map]
    )
  end
end
