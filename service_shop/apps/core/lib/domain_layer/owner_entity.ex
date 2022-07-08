defmodule Core.DomainLayer.OwnerEntity do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Id
  alias Core.DomainLayer.ValueObjects.Created
  alias Core.DomainLayer.ValueObjects.Email

  alias Core.DomainLayer.Dtos.ImpossibleCreateError
  alias Core.DomainLayer.Dtos.ImpossibleUpdateError

  alias Core.DomainLayer.OwnerEntity

  defstruct email: nil, id: nil, created: nil

  @type t :: %OwnerEntity{
          email: Email.t(),
          id: Id.t(),
          created: Created.t()
        }

  @type ok :: {:ok, OwnerEntity.t()}

  @type error_creating ::
          Email.error()
          | {:error, ImpossibleCreateError.t()}

  @spec new(binary()) :: ok() | error_creating()
  def new(email) when is_binary(email) do
    case Email.new(email) do
      {:error, error_dto} -> {:error, error_dto}
      {:ok, value_email} ->

        {
          :ok,
          %OwnerEntity{
            email: value_email,
            id: Id.new(),
            created: Created.new()
          }
        }
    end
  end

  def new(_) do
    {:error, ImpossibleCreateError.new()}
  end

  @spec update(OwnerEntity.t(), binary()) :: ok() | error_updating()
  def update(%OwnerEntity{
        email: %Email{value: email},
        id: %Id{value: id},
        created: %Created{value: _}
      }, new_email) when is_binary(new_email) do

    case Email.new(new_email) do
      {:ok, value_email} ->

        {
          :ok,
          %AvatarEntity{
            email: value_email,
            id: %Id{value: id},
            created: Created.new(),
          }
        }
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  def update(_, _) do
    {:error, ImpossibleUpdateError.new()}
  end
end
