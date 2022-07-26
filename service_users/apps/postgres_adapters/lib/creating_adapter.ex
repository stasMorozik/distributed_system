defmodule CreatingAdapter do
  @moduledoc false

  alias Ecto.Multi
  alias Users.Repo

  alias Core.DomainLayer.UserAggregate
  alias Core.DomainLayer.Ports.CreatingPort
  alias Core.DomainLayer.Dtos.ImpossibleCreateError
  alias Core.DomainLayer.Dtos.AlreadyExistsError

  alias Users.UsersSchema

  @behaviour CreatingPort

  @spec create(UserAggregate.t()) :: CreatingPort.ok() | CreatingPort.error()
  def create(%UserAggregate{} = entity) do

    user_changeset = %UsersSchema{} |> UsersSchema.changeset(%{
      name: entity.name.value,
      surname: entity.surname.value,
      email: entity.email.value,
      phone: entity.phone.value,
      password: entity.password.value,
      created: entity.created.value,
      id: entity.id.value,
      avatar: %{
        id: entity.avatar.id.value,
        created: entity.avatar.created.value,
        image: entity.avatar.image.value,
        user_id: entity.id.value
      }
    })

    case Multi.new() |> Multi.insert(:users, user_changeset) |> Repo.transaction() do
      {:ok, _} -> {:ok, true}
      _ -> {:error, AlreadyExistsError.new()}
    end

  end

  def create(_) do
  {:error, ImpossibleCreateError.new()}
  end
end
