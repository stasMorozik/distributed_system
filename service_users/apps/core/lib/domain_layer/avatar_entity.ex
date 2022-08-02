defmodule Core.DomainLayer.AvatarEntity do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Id
  alias Core.DomainLayer.ValueObjects.Created
  alias Core.DomainLayer.ValueObjects.Image

  alias Core.DomainLayer.Errors.DomainError

  alias Core.DomainLayer.AvatarEntity

  defstruct id: nil, created: nil, image: nil

  @type t :: %AvatarEntity{
          id: Id.t(),
          created: Created.t(),
          image: Image.t()
        }

  @type ok :: {:ok, AvatarEntity.t()}

  @type error :: {:error, DomainError.t()}

  @spec new(binary()) :: ok() | error()
  def new(img) when is_binary(img) do
    case Image.new(img) do
      {:ok, value_image} ->

        {
          :ok,
          %AvatarEntity{
            id: Id.new(),
            created: Created.new(),
            image: value_image
          }
        }
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  def new (_) do
    {:error, DomainError.new("Invalid input data")}
  end

  @spec update(AvatarEntity.t(), binary()) :: ok() | error()
  def update(%AvatarEntity{
        id: %Id{value: id},
        created: %Created{value: _},
        image: %Image{value: _}
      }, new_image) when is_binary(new_image) do

    case Image.new(new_image) do
      {:ok, value_image} ->

        {
          :ok,
          %AvatarEntity{
            id: %Id{value: id},
            created: Created.new(),
            image: value_image
          }
        }
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  def update(_, _) do
    {:error, DomainError.new("Invalid input data")}
  end
end
