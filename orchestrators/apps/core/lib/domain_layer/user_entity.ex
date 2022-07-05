defmodule Core.DomainLayer.UserEntity do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Image
  alias Core.DomainLayer.ValueObjects.Created
  alias Core.DomainLayer.ValueObjects.PhoneNumber
  alias Core.DomainLayer.ValueObjects.Name
  alias Core.DomainLayer.ValueObjects.Id
  alias Core.DomainLayer.ValueObjects.Email
  alias Core.DomainLayer.ValueObjects.Surname
  alias Core.DomainLayer.ValueObjects.Password

  alias Core.DomainLayer.UserEntity

  defstruct name: nil,
            surname: nil,
            email: nil,
            phone: nil,
            password: nil,
            avatar: nil,
            id: nil,
            created: nil

  @type t :: %UserEntity{
          name: Name.t(),
          surname: Surname.t(),
          email: Email.t(),
          phone: PhoneNumber.t(),
          password: Password.t(),
          avatar: Image.t(),
          id: Id.t(),
          created: Created.t()
        }
end
