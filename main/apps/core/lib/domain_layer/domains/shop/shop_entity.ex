defmodule Core.DomainLayer.Domains.Shop.ShopEntity do
  @moduledoc """
    Shop Entity
  """

  alias Core.DomainLayer.Domains.Shop.ShopEntity

  alias Core.DomainLayer.Common.ValueObjects.Id
  alias Core.DomainLayer.Common.ValueObjects.Created
  alias Core.DomainLayer.Common.ValueObjects.Name
  alias Core.DomainLayer.Common.ValueObjects.Image
  alias Core.DomainLayer.Common.ValueObjects.Like
  alias Core.DomainLayer.Common.ValueObjects.Dislike
  alias Core.DomainLayer.Common.ValueObjects.Description

  alias Core.DomainLayer.Common.Dtos.ImpossibleUpdateError
  alias Core.DomainLayer.Common.Dtos.ImpossibleCreateError
  alias Core.DomainLayer.Common.Dtos.NameIsInvalidError
  alias Core.DomainLayer.Common.Dtos.AlreadyExistsError
  alias Core.DomainLayer.Common.Dtos.DescriptionIsInvalidError
  alias Core.DomainLayer.Common.Dtos.ImageIsInvalidError

  alias Core.DomainLayer.Common.Dtos.ChangingNameData
  alias Core.DomainLayer.Common.Dtos.ChangingDescriptionData
  alias Core.DomainLayer.Common.Dtos.ChangingLogoData

  alias Core.DomainLayer.Domains.Shop.Dtos.CreatingData

  alias Core.DomainLayer.Domains.User.UserEntity

  alias Core.DomainLayer.Domains.Buyer.BuyerEntity

  defstruct name: nil,
            logo: nil,
            likes: nil,
            dislikes: nil,
            owner: nil,
            id: nil,
            created: nil,
            description: nil

  @type t :: %ShopEntity{
          name: Name.t(),
          logo: Image.t(),
          likes: list(Like.t()),
          dislikes: list(Dislike.t()),
          owner: UserEntity.t(),
          id: Id.t(),
          created: Created.t(),
          description: Description.t()
        }

  @type ok :: {
          :ok,
          ShopEntity.t()
        }

  @type error_creating :: {
          :error,
          ImpossibleCreateError.t()
          | NameIsInvalidError.t()
          | DescriptionIsInvalidError.t()
          | ImageIsInvalidError.t()
        }

  @type error_changing_name :: {
          :error,
          NameIsInvalidError.t()
          | ImpossibleUpdateError.t()
        }

  @type error_changing_logo :: {
          :error,
          ImageIsInvalidError.t()
          | ImpossibleUpdateError.t()
        }

  @type error_changing_description :: {
          :error,
          DescriptionIsInvalidError.t()
          | ImpossibleUpdateError.t()
        }

  @type error_voting :: {
          :error,
          ImpossibleCreateError.t()
          | AlreadyExistsError.t()
        }

  @spec new(CreatingData.t(), UserEntity.t()) :: ok() | error_creating()
  def new(%CreatingData{} = dto, %UserEntity{} = user_entity) do

    with {:ok, value_name} <- Name.new(dto.name),
         {:ok, value_desc} <- Description.new(dto.description),
         {:ok, value_image} <- Image.new(dto.logo) do
      {
        :ok,
        %ShopEntity{
          name: value_name,
          owner: user_entity,
          logo: value_image,
          likes: [],
          dislikes: [],
          id: Id.new(),
          created: Created.new(),
          description: value_desc
        }
      }
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  def new(_, _) do
    ImpossibleCreateError.new("Impossible create Shop for invalid data")
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
            logo: entity.logo,
            likes: entity.likes,
            dislikes: entity.dislikes,
            id: entity.id,
            created: entity.created,
            description: entity.description
          }
        }
    end
  end

  def change_name(_, _) do
    ImpossibleUpdateError.new("Impossible change name for invalid data")
  end

  @spec change_description(ChangingDescriptionData.t(), ShopEntity.t()) :: ok() | error_changing_description()
  def change_description(%ChangingDescriptionData{} = dto, %ShopEntity{} = entity) do
    case Description.new(dto.description) do
      {:error, error_dto} -> {:error, error_dto}
      {:ok, value_desc} ->

        {
          :ok,
          %ShopEntity{
            name: entity.name,
            owner: entity.owner,
            logo: entity.logo,
            likes: entity.likes,
            dislikes: entity.dislikes,
            id: entity.id,
            created: entity.created,
            description: value_desc
          }
        }
    end
  end

  def change_description(_, _) do
    ImpossibleUpdateError.new("Impossible change description for invalid data")
  end

  @spec change_logo(ChangingLogoData.t(), ShopEntity.t()) :: ok() | error_changing_logo()
  def change_logo(%ChangingLogoData{} = dto, %ShopEntity{} = entity) do
    case Image.new(dto.logo) do
      {:error, error_dto} -> {:error, error_dto}
      {:ok, value_logo} ->

        {
          :ok,
          %ShopEntity{
            name: entity.name,
            owner: entity.owner,
            logo: value_logo,
            likes: entity.likes,
            dislikes: entity.dislikes,
            id: entity.id,
            created: entity.created,
            description: entity.description
          }
        }
    end
  end

  def change_logo(_, _) do
    ImpossibleUpdateError.new("Impossible change logo for invalid data")
  end

  @spec like(ShopEntity.t(), BuyerEntity.t()) :: ok() | error_voting()
  def like(%ShopEntity{} = entity, %BuyerEntity{} = buyer_entity) do
    found = Enum.find(entity.likes, fn %Like{value: id} -> id == buyer_entity.id end)
    with true <- found != nil,
         {:ok, value_like} <- Like.new(buyer_entity.id) do
      {
        :ok,
        %ShopEntity{
          name: entity.name,
          owner: entity.owner,
          logo: entity.logo,
          likes: [value_like | entity.likes],
          dislikes: Enum.find(entity.dislikes, fn %Dislike{value: id} -> id != buyer_entity.id end),
          id: entity.id,
          created: entity.created,
          description: entity.description
        }
      }
    else
      {:error, error_dto} -> {:error, error_dto}
      false -> {:error, AlreadyExistsError.new("Buyer with this id already have liked this Shop")}
    end
  end

  def like(_, _) do
    ImpossibleUpdateError.new("Impossible liking for invalid data")
  end

  @spec dislike(ShopEntity.t(), BuyerEntity.t()) :: ok() | error_voting()
  def dislike(%ShopEntity{} = entity, %BuyerEntity{} = buyer_entity) do
    found = Enum.find(entity.dislikes, fn %Dislike{value: id} -> id == buyer_entity.id end)
    with true <- found != nil,
         {:ok, value_dislike} <- Dislike.new(buyer_entity.id) do
      {
        :ok,
        %ShopEntity{
          name: entity.name,
          owner: entity.owner,
          logo: entity.logo,
          likes: Enum.find(entity.likes, fn %Like{value: id} -> id != buyer_entity.id end),
          dislikes: [value_dislike | entity.dislikes],
          id: entity.id,
          created: entity.created,
          description: entity.description
        }
      }
    else
      {:error, error_dto} -> {:error, error_dto}
      false -> {:error, AlreadyExistsError.new("Buyer with this id already have disliked this Shop")}
    end
  end

  def dislike(_, _) do
    ImpossibleUpdateError.new("Impossible disliking for invalid data")
  end
end
