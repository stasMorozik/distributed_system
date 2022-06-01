defmodule Adapters.AdaptersPassword.ChangingPasswordAdapter do
  alias Core.CoreDomains.Domains.Password
  alias Core.CoreDomains.Domains.Password.ValueObjects.Password, as: ValuePassword
  alias Core.CoreDomains.Common.ValueObjects.Id

  alias Core.CoreDomains.Domains.Password.Ports.ChangingPasswordPort

  alias Core.CoreDomains.Domains.Password

  alias Core.CoreDomains.Domains.Password.Dtos.NotFoundError
  alias Core.CoreDomains.Domains.Password.Dtos.ImpossibleChangeError
  alias Core.CoreDomains.Common.Dtos.IdIsInvalidError

  @behaviour ChangingPasswordPort

  @spec change(Password.t()) :: ChangingPasswordPort.ok() | ChangingPasswordPort.error()
  def change(%Password{
    confirmed: confirmed,
    confirmed_code: confirmed_code,
    email: email,
    id: %Id{value: id},
    password: %ValuePassword{value: password},
    created: created
  }) when is_binary(id) and is_binary(password) do
    case UUID.info(id) do
      {:error, _} -> {:error, IdIsInvalidError.new()}
      {:ok, _} ->
        case Node.connect(Application.get_env(:adapters_password, :remote_node)) do
          :false -> {:error, ImpossibleChangeError.new("Postgres password service unavailable")}
          :ignored -> {:error, ImpossibleChangeError.new("Postgres password service unavailable")}
          :true ->
            case generate_task(id, password) |> Task.await() do
              {:ok, _} -> {:ok, %Password{
                confirmed: confirmed,
                confirmed_code: confirmed_code,
                email: email,
                id: %Id{value: id},
                password: %ValuePassword{value: password},
                created: created
              }}
              {:error, _} -> {:error, NotFoundError.new()}
            end
        end
    end
  end

  def change(_) do
    {:error, ImpossibleChangeError.new("Impossible change password into database for invalid data")}
  end

  defp generate_task(id, password) do
    Task.Supervisor.async(
      Application.get_env(:adapters_password, :remote_supervisor),
      Application.get_env(:adapters_password, :remote_module),
      :change_password,
      [id, password]
    )
  end
end
