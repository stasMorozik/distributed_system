defmodule GettingAdapter do
  @moduledoc false

  import Ecto.Query
  alias Users.Repo

  alias Core.DomainLayer.Ports.GettingPort

  alias Core.DomainLayer.UserAggregate
  alias Core.DomainLayer.AvatarEntity

  alias Core.DomainLayer.Dtos.NotFoundError
  alias Core.DomainLayer.Dtos.ImpossibleGetError

  alias Core.DomainLayer.ValueObjects.Image
  alias Core.DomainLayer.ValueObjects.Created
  alias Core.DomainLayer.ValueObjects.PhoneNumber
  alias Core.DomainLayer.ValueObjects.Name
  alias Core.DomainLayer.ValueObjects.Id
  alias Core.DomainLayer.ValueObjects.Email
  alias Core.DomainLayer.ValueObjects.Surname
  alias Core.DomainLayer.ValueObjects.Password

  alias Users.UsersSchema

  @behaviour GettingPort

  @spec get(Id.t()) :: GettingPort.ok() | GettingPort.error()
  def get(%Id{value: id}) do
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
          %UserAggregate{
            name: %Name{value: user.name},
            surname: %Surname{value: user.surname},
            email: %Email{value: user.email},
            phone: %PhoneNumber{value: user.phone},
            password: %Password{value: user.password},
            created: %Created{value: user.created},
            id: %Id{value: user.id},
            avatar: %AvatarEntity{
              image: %Image{value: user.avatar.image},
              id: %Id{value: user.avatar.id},
              created: %Created{value: user.avatar.created}
            }
          }
        }
    end
  end

  def get(_) do
    {:error, ImpossibleGetError.new()}
  end
end
