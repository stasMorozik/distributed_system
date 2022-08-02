defmodule UpdatingAdapter do
  @moduledoc false

  alias Ecto.Multi
  alias Users.Repo

  alias Core.DomainLayer.Ports.UpdatingPort

  alias Core.DomainLayer.Errors.InfrastructureError

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
      {:ok, _} ->
        {:ok, true}

      error ->
        with {:error, _, error_changeset, _} <- error,
             [head| _] <- error_changeset.errors,
             {:email, {"has already been taken", _}} <- head do
          {:error, InfrastructureError.new("User with this email already exists")}
        else
          _ -> {:error, InfrastructureError.new("Something went wrong")}
        end
    end
  end

  def update(_) do
    {:error, InfrastructureError.new("Invalid input data for updating")}
  end
end
