defmodule PostgresAdapters do
  @moduledoc false

  alias Ecto.Multi
  alias Users.Repo

  alias Ecto.Changeset

  alias Core.DomainLayer.Ports.CreatingPort
  alias Core.DomainLayer.Ports.GettingByEmailPort
  alias Core.DomainLayer.Ports.GettingPort
  alias Core.DomainLayer.Ports.UpdatingPort

  alias Core.DomainLayer.UserEntity

  alias Core.DomainLayer.Dtos.AlreadyExistsError

  alias Users.UsersSchema
  alias Users.AvatarsSchema

  @behaviour CreatingPort
  @behaviour GettingByEmailPort
  @behaviour GettingPort
  @behaviour UpdatingPort

  # {:ok, user} = Core.DomainLayer.UserEntity.new(%{name: "test", surname: "test", email: "test1@gmail.com", phone: "8908769", password: "123456", avatar: "sddsfgsdfgsdfgsdgfsdfggsdgf"})
  # PostgresAdapters.create(user)

  @spec create(UserEntity.t()) :: CreatingPort.ok() | CreatingPort.error()
  def create(%UserEntity{} = entity) do
    user =
      %UsersSchema{}
      |> UsersSchema.changeset(%{
        name: entity.name.value,
        surname: entity.surname.value,
        email: entity.email.value,
        phone: entity.phone.value,
        password: entity.password.value,
        created: entity.created.value,
        id: entity.id.value,
        avatar: %{
          image: entity.avatar.value,
          created: entity.avatar.created,
          id: entity.avatar.id,
          user_id: entity.id.value
        }
      })

    case Multi.new() |> Multi.insert(:users, user) |> Repo.transaction() do
      {:ok, _} -> {:ok, true}
      e -> {:error, AlreadyExistsError.new()}
    end
  end
end
