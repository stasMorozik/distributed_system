defmodule Adapters.AdaptersUser.CreatingAdapter do
  alias Core.CoreDomains.Domains.User.Ports.CreatingPort

  alias alias Core.CoreDomains.Domains.User

  alias Core.CoreDomains.Domains.User.Dtos.ImpossibleCreateError
  alias Core.CoreDomains.Domains.User.Dtos.AlreadyExistsError
  alias Core.CoreDomains.Common.Dtos.IdIsInvalidError

  alias Core.CoreDomains.Common.ValueObjects.Id
  alias Core.CoreDomains.Common.ValueObjects.Created
  alias Core.CoreDomains.Common.ValueObjects.Name

  @behaviour CreatingPort

  @spec create(User.t()) :: CreatingPort.error() | CreatingPort.ok()
  def create(%User{
    id: %Id{value: id},
    name: %Name{value: name},
    created: %Created{value: created}
  }) when
    is_binary(id) and
    is_binary(name) do
      case UUID.info(id) do
        {:error, _} -> {:error, IdIsInvalidError.new()}
        {:ok, _} ->
          case Node.connect(Application.get_env(:adapters_user, :remote_node)) do
            :false -> {:error, ImpossibleCreateError.new("User service postgres unavailable")}
            :ignored -> {:error, ImpossibleCreateError.new("User service postgres unavailable")}
            :true ->
              case generate_task(id, name, created) |> Task.await() do
                {:ok, _} -> {:ok, %User{
                  id: %Id{value: id},
                  name: %Name{value: name},
                  created: %Created{value: created}
                }}
                {:error, _} -> {:error, AlreadyExistsError.new()}
              end
          end
      end
  end

  def create(_) do
    {:error, ImpossibleCreateError.new("Impossible create user into database for invalid data")}
  end

  defp generate_task(id, name, created) do
    Task.Supervisor.async(
      Application.get_env(:adapters_user, :remote_supervisor),
      Application.get_env(:adapters_user, :remote_module),
      :create,
      [id, name, created]
    )
  end
end
