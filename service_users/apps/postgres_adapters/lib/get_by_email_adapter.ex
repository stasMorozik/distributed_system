defmodule GetByEmailAdapter do
  @moduledoc false

  import Ecto.Query
  alias Users.Repo

  alias Core.DomainLayer.Ports.GettingByEmailPort

  alias Core.DomainLayer.ValueObjects.Email

  alias Core.DomainLayer.Errors.InfrastructureError

  alias Core.DomainLayer.UserAggregate
  alias Core.DomainLayer.AvatarEntity

  alias Core.DomainLayer.ValueObjects.Email
  alias Core.DomainLayer.ValueObjects.Image
  alias Core.DomainLayer.ValueObjects.Created
  alias Core.DomainLayer.ValueObjects.PhoneNumber
  alias Core.DomainLayer.ValueObjects.Name
  alias Core.DomainLayer.ValueObjects.Id
  alias Core.DomainLayer.ValueObjects.Email
  alias Core.DomainLayer.ValueObjects.Surname
  alias Core.DomainLayer.ValueObjects.Password

  alias Users.UsersSchema

  @behaviour GettingByEmailPort

  @spec get_by_email(Email.t()) :: GettingByEmailPort.ok() | GettingByEmailPort.error()
  def get_by_email(%Email{value: email}) do
    query =
      from(u in UsersSchema,
        join: a in assoc(u, :avatar),
        where: u.email == ^email,
        preload: [avatar: a]
      )

    case Repo.one(query) do
      nil ->
        {:error, InfrastructureError.new("User not found")}

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

  def get_by_email(_) do
    {:error, InfrastructureError.new("Invalid input data for select")}
  end
end
