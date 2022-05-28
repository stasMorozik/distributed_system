defmodule Core.CoreDomains.Domains.User do
  alias Core.CoreDomains.Domains.User
  alias Core.CoreDomains.Domains.Password

  alias Core.CoreDomains.Common.ValueObjects.Id
  alias Core.CoreDomains.Common.ValueObjects.Created
  alias Core.CoreDomains.Common.ValueObjects.Name

  alias Core.CoreDomains.Domains.Password.ValueObjects.Confirmed

  alias Core.CoreDomains.Common.Dtos.NameIsInvalidError
  alias Core.CoreDomains.Common.Dtos.IdIsInvalidError
  alias Core.CoreDomains.Domains.User.Dtos.ImpossibleCreateError

  defstruct id: nil, name: nil, created: nil

  @type t :: %User{
    id: Id.t(),
    name: Name.t(),
    created: Created.t()
  }

  @type ok ::
  {
    :ok,
    User.t()
  }

  @type error ::
  {
    :error,
    NameIsInvalidError.t()    |
    IdIsInvalidError.t()      |
    ImpossibleCreateError.t()
  }

  @doc """
   Function creating user.
   To create user must create password.
  """
  @spec create(Password.t(), binary) :: ok | error
  def create(%Password{
    confirmed: %Confirmed{value: false},
    confirmed_code: _,
    email: _,
    id: %Id{value: id},
    password: _,
    created: _
  }, name) when is_binary(id) and is_binary(name) do
    case Name.new(name) do
      {:error, dto} -> {:error, dto}
      {:ok, name_value} -> {:ok, %User{
        id: %Id{value: id},
        name: name_value,
        created: Created.new()
      }}
    end
  end

  def create(%Password{
    confirmed: %Confirmed{value: false},
    confirmed_code: _,
    email: _,
    id: %Id{value: id},
    password: _,
    created: _
  }, _) when is_binary(id) do
    {:error, NameIsInvalidError.new()}
  end

  def create(%Password{
    confirmed: %Confirmed{value: false},
    confirmed_code: _,
    email: _,
    id: _,
    password: _,
    created: _
  }, name) when is_binary(name) do
    {:error, IdIsInvalidError.new()}
  end

  def create(_, _) do
    {:error, ImpossibleCreateError.new()}
  end
end
