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
  alias Core.DomainLayer.Common.Dtos.AuthorizatingData
  alias Core.DomainLayer.Common.Dtos.ChangingLogoData

  alias Core.DomainLayer.Domains.Shop.Dtos.CreatingData
  alias Core.DomainLayer.Domains.Shop.Dtos.UpdatingData

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

  @type error_changing_data :: {
          :error,
          NameIsInvalidError.t()
          | DescriptionIsInvalidError.t()
          | ImpossibleUpdateError.t()
        }

  @type error_changing_logo :: {
          :error,
          ImageIsInvalidError.t()
          | ImpossibleUpdateError.t()
        }

  @type error_voting :: {
          :error,
          ImpossibleCreateError.t()
          | AlreadyExistsError.t()
        }

  @spec new(AuthorizatingData.t(), CreatingData.t()) ::
          ok() | error_creating() | UserEntity.error_authorizating()
  def new(%AuthorizatingData{} = authorizating_dto, %CreatingData{} = dto) do
    with {:ok, user_entity} <-
           UserEntity.authorizate(authorizating_dto),
         {:ok, value_name} <- Name.new(dto.name),
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

  @spec change_data(
          AuthorizatingData.t(),
          UpdatingData.t(),
          ShopEntity.t()
        ) :: ok() | error_changing_data() | UserEntity.error_authorizating()
  def change_data(
        %AuthorizatingData{} = authorizating_dto,
        %UpdatingData{} = dto,
        %ShopEntity{} = entity
      )
      when is_binary(dto.name) and is_binary(dto.description) do
    with {:ok, _} <- UserEntity.authorizate(authorizating_dto),
         {:ok, value_name} <- Name.new(dto.name),
         {:ok, value_desc} <- Description.new(dto.description) do
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
          description: value_desc
        }
      }
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  def change_data(
        %AuthorizatingData{} = authorizating_dto,
        %UpdatingData{} = dto,
        %ShopEntity{} = entity
      )
      when is_binary(dto.name) do
    with {:ok, _} <- UserEntity.authorizate(authorizating_dto),
         {:ok, value_name} <- Name.new(dto.name) do
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
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  def change_data(
        %AuthorizatingData{} = authorizating_dto,
        %UpdatingData{} = dto,
        %ShopEntity{} = entity
      )
      when is_binary(dto.description) do
    with {:ok, _} <- UserEntity.authorizate(authorizating_dto),
         {:ok, value_desc} <- Description.new(dto.description) do
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
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  def change_data(_, _, _) do
    {:error, ImpossibleUpdateError.new("Impossible change name or description for ivalid data")}
  end

  @spec change_logo(
          AuthorizatingData.t(),
          ChangingLogoData.t(),
          ShopEntity.t()
        ) :: ok() | error_changing_logo() | UserEntity.error_authorizating()
  def change_logo(
        %AuthorizatingData{} = authorizating_dto,
        %ChangingLogoData{} = dto,
        %ShopEntity{} = entity
      ) do
    with {:ok, _} <- UserEntity.authorizate(authorizating_dto),
         {:ok, value_image} <- Image.new(dto.logo) do
      {
        :ok,
        %ShopEntity{
          name: entity.name,
          owner: entity.owner,
          logo: value_image,
          likes: entity.likes,
          dislikes: entity.dislikes,
          id: entity.id,
          created: entity.created,
          description: entity.description
        }
      }
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  def change_logo(_, _, _) do
    ImpossibleUpdateError.new("Impossible change logo for invalid data")
  end

  @spec like(AuthorizatingData.t(), ShopEntity.t()) ::
          ok() | error_voting() | BuyerEntity.error_authorizating()
  def like(%AuthorizatingData{} = authorizating_dto, %ShopEntity{} = entity) do
    case BuyerEntity.authorizate(authorizating_dto) do
      {:ok, buyer_entity} ->
        found = Enum.find(entity.likes, fn %Like{value: id} -> id == buyer_entity.id end)
        with true <- found == nil,
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
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  def like(_, _, _) do
    ImpossibleUpdateError.new("Impossible liking for invalid data")
  end

  @spec dislike(AuthorizatingData.t(), ShopEntity.t()) :: ok() | error_voting() | BuyerEntity.error_authorizating()
  def dislike(%AuthorizatingData{} = authorizating_dto, %ShopEntity{} = entity) do
    case BuyerEntity.authorizate(authorizating_dto) do
      {:ok, buyer_entity} ->
        found = Enum.find(entity.dislikes, fn %Dislike{value: id} -> id == buyer_entity.id end)
        with true <- found == nil,
             {:ok, value_dislike} <- Like.new(buyer_entity.id) do

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
          false -> {:error, AlreadyExistsError.new("Buyer with this id already have liked this Shop")}
        end
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  def dislike(_, _, _) do
    ImpossibleUpdateError.new("Impossible disliking for invalid data")
  end
end
