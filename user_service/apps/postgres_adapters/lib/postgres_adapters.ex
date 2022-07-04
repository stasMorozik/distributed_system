defmodule PostgresAdapters do
  @moduledoc false

  alias Ecto.Multi
  import Ecto.Query
  alias Users.Repo

  alias Core.DomainLayer.Ports.CreatingPort
  alias Core.DomainLayer.Ports.GettingByEmailPort
  alias Core.DomainLayer.Ports.GettingPort
  alias Core.DomainLayer.Ports.UpdatingPort

  alias Core.DomainLayer.UserEntity
  alias Core.DomainLayer.ValueObjects.Email

  alias Core.DomainLayer.Dtos.NotFoundError
  alias Core.DomainLayer.Dtos.ImpossibleCreateError
  alias Core.DomainLayer.Dtos.ImpossibleGetError
  alias Core.DomainLayer.Dtos.ImpossibleUpdateError
  alias Core.DomainLayer.Dtos.AlreadyExistsError

  alias Core.DomainLayer.ValueObjects.Image
  alias Core.DomainLayer.ValueObjects.Created
  alias Core.DomainLayer.ValueObjects.PhoneNumber
  alias Core.DomainLayer.ValueObjects.Name
  alias Core.DomainLayer.ValueObjects.Id
  alias Core.DomainLayer.ValueObjects.Email
  alias Core.DomainLayer.ValueObjects.Surname
  alias Core.DomainLayer.ValueObjects.Password

  alias Users.UsersSchema
  alias Users.AvatarsSchema

  @behaviour CreatingPort
  @behaviour GettingByEmailPort
  @behaviour GettingPort
  @behaviour UpdatingPort

  @spec create(UserEntity.t()) :: CreatingPort.ok() | CreatingPort.error()
  def create(%UserEntity{
        name: %Name{value: name},
        surname: %Surname{value: surname},
        email: %Email{value: email},
        phone: %PhoneNumber{value: phone},
        password: %Password{value: password},
        avatar: %Image{value: avatar, id: id_ava, created: created_ava},
        id: %Id{value: id},
        created: %Created{value: created}
      }) do

    IO.inspect(%UserEntity{
      name: %Name{value: name},
      surname: %Surname{value: surname},
      email: %Email{value: email},
      phone: %PhoneNumber{value: phone},
      password: %Password{value: password},
      avatar: %Image{value: avatar, id: id_ava, created: created_ava},
      id: %Id{value: id},
      created: %Created{value: created}
    })

    is_date_time = fn
      %DateTime{} = _ -> true
      _ -> false
    end

    with true <- is_binary(name),
         true <- is_binary(surname),
         true <- is_binary(email),
         true <- is_binary(phone),
         true <- is_binary(password),
         true <- is_binary(avatar),
         true <- is_binary(id_ava),
         true <- is_binary(id),
         true <- is_struct(created),
         true <- is_struct(created_ava),
         true <- is_date_time.(created),
         true <- is_date_time.(created_ava),
         {:ok, _} <- UUID.info(id),
         {:ok, _} <- UUID.info(id_ava) do
      _create(%{
        name: name,
        surname: surname,
        email: email,
        phone: phone,
        password: password,
        created: created,
        id: id,
        avatar: %{
          image: avatar,
          created: created_ava,
          id: id_ava,
          user_id: id
        }
      })
    else
      false -> {:error, ImpossibleCreateError.new()}
      {:ok, _} -> {:error, ImpossibleCreateError.new()}
    end
  end

  def create(_) do
    {:error, ImpossibleCreateError.new()}
  end

  defp _create(schema) do
    user = %UsersSchema{} |> UsersSchema.changeset(schema)

    case Multi.new() |> Multi.insert(:users, user) |> Repo.transaction() do
      {:ok, _} -> {:ok, true}
      _ -> {:error, AlreadyExistsError.new()}
    end
  end

  @spec get_by_email(Email.t()) :: GettingByEmailPort.ok() | GettingByEmailPort.error()
  def get_by_email(%Email{value: email}) when is_binary(email) do
    query =
      from(u in UsersSchema,
        join: a in assoc(u, :avatar),
        where: u.email == ^email,
        preload: [avatar: a]
      )

    case Repo.one(query) do
      nil ->
        {:error, NotFoundError.new()}

      user ->
        {
          :ok,
          %UserEntity{
            name: %Name{value: user.name},
            surname: %Surname{value: user.surname},
            email: %Email{value: user.email},
            phone: %PhoneNumber{value: user.phone},
            password: %Password{value: user.password},
            created: %Created{value: user.created},
            id: %Id{value: user.id},
            avatar: %Image{
              value: user.avatar.image,
              id: user.avatar.id,
              created: user.avatar.created
            }
          }
        }
    end
  end

  def get_by_email(_) do
    {:error, ImpossibleGetError.new()}
  end

  @spec get(Id.t()) :: GettingPort.ok() | GettingPort.error()
  def get(%Id{value: id}) when is_binary(id) do
    case UUID.info(id) do
      {:error, _} ->
        {:error, ImpossibleGetError.new()}

      {:ok, _} ->
        query =
          from(u in UsersSchema,
            join: a in assoc(u, :avatar),
            where: u.id == ^id,
            preload: [avatar: a]
          )

        case Repo.one(query) do
          nil ->
            {:error, NotFoundError.new()}

          user ->
            {
              :ok,
              %UserEntity{
                name: %Name{value: user.name},
                surname: %Surname{value: user.surname},
                email: %Email{value: user.email},
                phone: %PhoneNumber{value: user.phone},
                password: %Password{value: user.password},
                created: %Created{value: user.created},
                id: %Id{value: user.id},
                avatar: %Image{
                  value: user.avatar.image,
                  id: user.avatar.id,
                  created: user.avatar.created
                }
              }
            }
        end
    end
  end

  def get(_) do
    {:error, ImpossibleGetError.new()}
  end

  @spec update(UserEntity.t()) :: UpdatingPort.ok() | UpdatingPort.error()
  def update(%UserEntity{
        name: %Name{value: name},
        surname: %Surname{value: surname},
        email: %Email{value: email},
        phone: %PhoneNumber{value: phone},
        password: %Password{value: password},
        avatar: %Image{value: avatar, id: id_ava, created: created_ava},
        id: %Id{value: id},
        created: %Created{value: created}
      }) do

    is_date_time = fn
      %DateTime{} = _ -> true
      _ -> false
    end

    with true <- is_binary(name),
         true <- is_binary(surname),
         true <- is_binary(email),
         true <- is_binary(phone),
         true <- is_binary(password),
         true <- is_binary(avatar),
         true <- is_binary(id_ava),
         true <- is_binary(id),
         true <- is_struct(created),
         true <- is_struct(created_ava),
         true <- is_date_time.(created),
         true <- is_date_time.(created_ava),
         {:ok, _} <- UUID.info(id),
         {:ok, _} <- UUID.info(id_ava) do
      _update(%{
        name: name,
        surname: surname,
        email: email,
        phone: phone,
        password: password,
        created: created,
        id: id,
        avatar: %{
          image: avatar,
          created: created_ava,
          id: id_ava,
          user_id: id
        }
      })
    else
      false -> {:error, ImpossibleUpdateError.new()}
      {:ok, _} -> {:error, ImpossibleUpdateError.new()}
    end
  end

  def update(_) do
    {:error, ImpossibleUpdateError.new()}
  end

  defp _update(schema) do
    changeset_user = %UsersSchema{id: schema.id} |> UsersSchema.update_changeset(%{
      name: schema.name,
      surname: schema.surname,
      email: schema.email,
      phone: schema.phone,
      password: schema.password,
    })

    changeset_avatar = %AvatarsSchema{id: schema.avatar.id} |> AvatarsSchema.update_changeset(%{
      image: schema.avatar.image,
      created: schema.avatar.created
    })

    case Multi.new()
         |> Multi.update(:users, changeset_user)
         |> Multi.update(:avatars, changeset_avatar)
         |> Repo.transaction() do
      {:ok, _} -> {:ok, true}
      {:error, _} -> {:error, AlreadyExistsError.new()}
    end
  end
end
