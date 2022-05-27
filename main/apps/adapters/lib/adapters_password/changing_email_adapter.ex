defmodule Adapters.AdaptersPassword.ChangingEmailAdapter do
  alias Core.CoreDomains.Domains.Password
  alias Core.CoreDomains.Domains.Password.ValueObjects.Email
  alias Core.CoreDomains.Common.ValueObjects.Id

  alias Core.CoreDomains.Domains.Password.Ports.ChangingEmailPort

  alias Core.CoreDomains.Domains.Password.Dtos.AlreadyExistsError
  alias Core.CoreDomains.Domains.Password.Dtos.ImpossibleChangeEmailError

  @behaviour ChangingEmailPort

  @spec change(Password.t()) :: ChangingEmailPort.ok() | ChangingEmailPort.error()
  def change(%Password{
    confirmed: confirmed,
    confirmed_code: confirmed_code,
    email: %Email{value: email},
    id: %Id{value: id},
    password: password,
    created: created
  }) when is_binary(email) and is_binary(id) do
    case UUID.info(id) do
      {:error, _} -> {:error, ImpossibleChangeEmailError.new()}
      {:ok, _} ->
        case Node.connect(:password_postgres_service@localhost) do
          :false -> {:error, ImpossibleChangeEmailError.new()}
          :ignored -> {:error, ImpossibleChangeEmailError.new()}
          :true ->
            case Task.Supervisor.async(
              {Passwords.Repo.TaskSupervisor, :password_postgres_service@localhost},
              PasswordPostgresService,
              :change_email, [id, email]
            ) |> Task.await() do
              {:ok, _} -> {:ok, %Password{
                confirmed: confirmed,
                confirmed_code: confirmed_code,
                email: %Email{value: email},
                id: %Id{value: id},
                password: password,
                created: created
              }}
              {:error, _} -> {:error, AlreadyExistsError.new()}
            end
        end
    end
  end

  def change(_) do
    {:error, ImpossibleChangeEmailError.new()}
  end
end
