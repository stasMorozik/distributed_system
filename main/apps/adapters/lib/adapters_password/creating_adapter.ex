defmodule Adapters.AdaptersPassword.CreatingAdapter do
  alias Core.CoreDomains.Domains.Password.Ports.CreatingPort

  alias Core.CoreDomains.Domains.Password.Dtos.AlreadyExistsError
  alias Core.CoreDomains.Domains.Password.Dtos.ImpossibleCreateError
  alias Core.CoreDomains.Common.Dtos.IdIsInvalidError

  alias alias Core.CoreDomains.Domains.Password

  alias Core.CoreDomains.Domains.Password.ValueObjects.Email
  alias Core.CoreDomains.Domains.Password.ValueObjects.ConfirmingCode
  alias Core.CoreDomains.Domains.Password.ValueObjects.Confirmed
  alias Core.CoreDomains.Domains.Password.ValueObjects.Password, as: ValuePassword
  alias Core.CoreDomains.Common.ValueObjects.Id
  alias Core.CoreDomains.Common.ValueObjects.Created

  @behaviour CreatingPort

  @spec create(Password.t()) :: CreatingPort.error() | CreatingPort.ok()
  def create(%Password{
    confirmed: %Confirmed{value: confirmed},
    confirmed_code: %ConfirmingCode{value: confirmed_code},
    email: %Email{value: email},
    id: %Id{value: id},
    password: %ValuePassword{value: password},
    created: %Created{value: created}
  }) when
    is_binary(id) and
    is_binary(email) and
    is_binary(password) and
    is_integer(confirmed_code) and
    is_boolean(confirmed)  do
      case UUID.info(id) do
        {:error, _} -> {:error, IdIsInvalidError.new()}
        {:ok, _} ->
          case Node.connect(Application.get_env(:adapters, :password_postgres_service)[:remote_node]) do
            :false -> {:error, ImpossibleCreateError.new("Postgres password service unavailable")}
            :ignored -> {:error, ImpossibleCreateError.new("Postgres password service unavailable")}
            :true ->
              pswd_map = %{
                id: id,
                password: password,
                email: email,
                confirmed: confirmed,
                confirmed_code: confirmed_code,
                created: created
              }
              case generate_task(pswd_map) |> Task.await() do
                {:ok, _} -> {:ok, %Password{
                  confirmed: %Confirmed{value: confirmed},
                  confirmed_code: %ConfirmingCode{value: confirmed_code},
                  email: %Email{value: email},
                  id: %Id{value: id},
                  password: %ValuePassword{value: password},
                  created: %Created{value: created}
                }}
                {:error, _} -> {:error, AlreadyExistsError.new()}
              end
          end
      end
  end

  def create(_) do
    {:error, ImpossibleCreateError.new("Impossible create password into database for invalid data")}
  end

  defp generate_task(password_map) do
    Task.Supervisor.async(
      Application.get_env(:adapters, :password_postgres_service)[:remote_supervisor],
      Application.get_env(:adapters, :password_postgres_service)[:remote_module],
      :create,
      [password_map]
    )
  end
end
