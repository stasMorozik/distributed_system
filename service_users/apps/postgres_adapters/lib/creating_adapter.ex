defmodule CreatingAdapter do
  @moduledoc false

  alias Ecto.Multi
  alias Users.Repo

  alias Core.DomainLayer.UserAggregate
  alias Core.DomainLayer.Ports.CreatingPort
  alias Core.DomainLayer.Errors.InfrastructureError

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

  def create(_) do
  {:error, InfrastructureError.new("Invalid input data for inserting")}
  end
end
