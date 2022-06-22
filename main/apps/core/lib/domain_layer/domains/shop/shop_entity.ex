defmodule Core.DomainLayer.Domains.Shop.ShopEntity do
  @moduledoc """
    User Entity
  """

  alias Core.DomainLayer.Domains.Shop.ShopEntity

  alias Core.DomainLayer.Common.ValueObjects.Id
  alias Core.DomainLayer.Common.ValueObjects.Created
  alias Core.DomainLayer.Common.ValueObjects.Name
  alias Core.DomainLayer.Common.ValueObjects.Avatar
  alias Core.DomainLayer.Common.ValueObjects.Likes

  alias Core.DomainLayer.Common.Dtos.ImpossibleUpdateError
  alias Core.DomainLayer.Common.Dtos.ImpossibleCreateError
  alias Core.DomainLayer.Common.Dtos.NameIsInvalidError

  alias Core.DomainLayer.Domains.Shop.Dtos.CreatingData
  alias Core.DomainLayer.Domains.Shop.Dtos.ChangingNameData
  alias Core.DomainLayer.Domains.Shop.Dtos.ChangingAvatarData

  alias Core.DomainLayer.Domains.User.UserEntity

  defstruct name: nil,
            avatar: nil,
            likes: nil,
            owner: nil,
            id: nil,
            created: nil

  @type t :: %ShopEntity{
          name: Name.t(),
          avatar: Avatar.t(),
          likes: Likes.t(),
          owner: Id.t(),
          id: Id.t(),
          created: Created.t()
        }

  @type ok :: {
          :ok,
          ShopEntity.t()
        }

  @type error_creating :: {
          :error,
          ImpossibleCreateError.t()
          | NameIsInvalidError.t()
        }

  @type error_changing_name :: {
          :error,
          NameIsInvalidError.t()
          | ImpossibleUpdateError.t()
        }

  @spec new(CreatingData.t(), UserEntity.t()) :: ok() | error_creating()
  def new(%CreatingData{} = dto, %UserEntity{} = user_entity) do
    case Name.new(dto.name) do
      {:error, error_dto} ->

        {:error, error_dto}
      {:ok, value_name} ->

        {
          :ok,
          %ShopEntity{
            name: value_name,
            owner: user_entity.id,
            avatar: Avatar.new(dto.avatar),
            likes: Likes.new(0),
            id: Id.new(),
            created: Created.new()
          }
        }
    end
  end

  def new(_, _) do
    ImpossibleCreateError.new("Impossible create Buyer for invalid data")
  end

  @spec change_name(ChangingNameData.t(), ShopEntity.t()) :: ok() | error_changing_name()
  def change_name(%ChangingNameData{} = dto, %ShopEntity{} = entity) do
    case Name.new(dto.name) do
      {:error, error_dto} ->

        {:error, error_dto}
      {:ok, value_name} ->

        {
          :ok,
          %ShopEntity{
            name: value_name,
            owner: entity.owner,
            avatar: entity.avatar,
            likes: entity.likes,
            id: entity.id,
            created: entity.created
          }
        }
    end
  end

  def change_name(_, _) do
    ImpossibleUpdateError.new("Impossible change name for invalid data")
  end

  @spec change_avatar(ChangingAvatarData.t(), ShopEntity.t()) :: ok()
  def change_avatar(%ChangingAvatarData{} = dto, %ShopEntity{} = entity) do
    {
      :ok,
      %ShopEntity{
        name: entity.name,
        owner: entity.owner,
        avatar: Avatar.new(dto.avatar),
        likes: entity.likes,
        id: entity.id,
        created: entity.created
      }
    }
  end

  @spec like(ShopEntity.t()) :: ok()
  def like(%ShopEntity{} = entity) do
    {
      :ok,
      %ShopEntity{
        name: entity.name,
        owner: entity.owner,
        avatar: entity.avatar,
        likes: Likes.new(entity.likes.value + 1),
        id: entity.id,
        created: entity.created
      }
    }
  end

  def like(_) do
    ImpossibleUpdateError.new("Impossible liking for invalid data")
  end
end
