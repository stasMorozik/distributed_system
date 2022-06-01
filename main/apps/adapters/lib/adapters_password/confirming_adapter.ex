defmodule Adapters.AdaptersPassword.ConfirmingAdapter do
  alias Core.CoreDomains.Domains.Password.Ports.ConfirmingPort

  alias Core.CoreDomains.Domains.Password

  alias Core.CoreDomains.Domains.Password.ValueObjects.Email
  alias Core.CoreDomains.Common.ValueObjects.Id
  alias Core.CoreDomains.Domains.Password.ValueObjects.ConfirmingCode

  alias Core.CoreDomains.Domains.Password.Dtos.NotFoundError
  alias Core.CoreDomains.Domains.Password.Dtos.ImpossibleConfirmError
  alias Core.CoreDomains.Common.Dtos.IdIsInvalidError

  @behaviour ConfirmingPort

  @spec confirm(Password.t()) :: ConfirmingPort.ok() | ConfirmingPort.error()
  def confirm(%Password{
    confirmed: confirmed,
    confirmed_code: %ConfirmingCode{value: confirmed_code},
    email: %Email{value: email},
    id: %Id{value: id},
    password: password,
    created: created
  }) when is_binary(id) and is_binary(email) and is_integer(confirmed_code) do
    case UUID.info(id) do
      {:error, _}-> {:error, IdIsInvalidError.new()}
      {:ok, _} ->
        case Node.connect(Application.get_env(:adapters_password, :remote_node)) do
          :false -> {:error, ImpossibleConfirmError.new("Postgres password service unavailable")}
          :ignored -> {:error, ImpossibleConfirmError.new("Postgres password service unavailable")}
          :true ->
            case generate_task(id, email, confirmed_code) |> Task.await() do
              {:ok, _} -> {:ok, %Password{
                confirmed: confirmed,
                email: %Email{value: email},
                id: %Id{value: id},
                password: password,
                created: created
              }}
              {:error, _} -> {:error, NotFoundError.new()}
            end
        end
    end
  end

  def confirm(_) do
    {:error, ImpossibleConfirmError.new("Impossible confirm email into database for invalid data")}
  end

  defp generate_task(id, email, confirmed_code) do
    Task.Supervisor.async(
      Application.get_env(:adapters_password, :remote_supervisor),
      Application.get_env(:adapters_password, :remote_module),
      :confirm,
      [id, email, confirmed_code]
    )
  end
end
