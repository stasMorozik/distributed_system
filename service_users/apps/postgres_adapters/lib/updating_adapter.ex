defmodule UpdatingAdapter do
  @moduledoc false

  alias Ecto.Multi
  alias Users.Repo

  alias Core.DomainLayer.Ports.UpdatingPort

  alias Core.DomainLayer.Dtos.ImpossibleUpdateError
  alias Core.DomainLayer.Dtos.AlreadyExistsError

  alias Core.DomainLayer.UserAggregate

  alias Users.UsersSchema
  alias Users.AvatarsSchema

  @behaviour UpdatingPort

  @spec update(UserAggregate.t()) :: UpdatingPort.ok() | UpdatingPort.error()
  def update(%UserAggregate{} = entity) do
    changeset_user = %UsersSchema{id: entity.id.value} |> UsersSchema.update_changeset(%{
      name: entity.name.value,
      surname: entity.surname.value,
      email: entity.email.value,
      phone: entity.phone.value,
      password: entity.password.value,
    })

    changeset_avatar = %AvatarsSchema{id: entity.avatar.id.value} |> AvatarsSchema.update_changeset(%{
      image: entity.avatar.image.value
    })

    case Multi.new()
         |> Multi.update(:users, changeset_user)
         |> Multi.update(:avatars, changeset_avatar)
         |> Repo.transaction() do
      {:ok, _} -> {:ok, true}
      {:error, _} -> {:error, AlreadyExistsError.new()}
    end
  end

  def update(_) do
    {:error, ImpossibleUpdateError.new()}
  end
end
