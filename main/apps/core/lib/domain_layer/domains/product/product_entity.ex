defmodule Core.DomainLayer.Domains.Product.ProductEntity do
  @moduledoc """
    Product Entity
  """

  alias Core.DomainLayer.Domains.Product.ProductEntity

  alias Core.DomainLayer.Common.ValueObjects.Id
  alias Core.DomainLayer.Common.ValueObjects.Created
  alias Core.DomainLayer.Common.ValueObjects.Name
  alias Core.DomainLayer.Common.ValueObjects.Image
  alias Core.DomainLayer.Common.ValueObjects.Like
  alias Core.DomainLayer.Common.ValueObjects.Dislike
  alias Core.DomainLayer.Common.ValueObjects.Amount
  alias Core.DomainLayer.Common.ValueObjects.Description

  alias Core.DomainLayer.Common.Dtos.ImpossibleUpdateError
  alias Core.DomainLayer.Common.Dtos.ImpossibleCreateError
  alias Core.DomainLayer.Common.Dtos.NameIsInvalidError
  alias Core.DomainLayer.Common.Dtos.AlreadyExistsError
  alias Core.DomainLayer.Common.Dtos.AmountIsInvalidError
  alias Core.DomainLayer.Common.Dtos.DescriptionIsInvalidError
  alias Core.DomainLayer.Common.Dtos.ImageIsInvalidError
  alias Core.DomainLayer.Common.Dtos.ImpossibleDeleteError

  alias Core.DomainLayer.Common.Dtos.UpdatingLogoData
  alias Core.DomainLayer.Common.Dtos.AuthorizatingData

  alias Core.DomainLayer.Domains.Product.Dtos.CreatingData
  alias Core.DomainLayer.Domains.Product.Dtos.UpdatingData
  alias Core.DomainLayer.Domains.Product.Dtos.DeletingImageData
  alias Core.DomainLayer.Domains.Product.Dtos.AddingImageData

  alias Core.DomainLayer.Domains.Shop.ShopEntity

  alias Core.DomainLayer.Domains.User.UserEntity

  alias Core.DomainLayer.Domains.Buyer.BuyerEntity

  defstruct name: nil,
            logo: nil,
            images: nil,
            likes: nil,
            dislikes: nil,
            id: nil,
            amount: nil,
            owner: nil,
            created: nil,
            description: nil

  @type t :: %ProductEntity{
          name: Name.t(),
          logo: Image.t(),
          images: list(Image.t()),
          likes: list(Like.t()),
          dislikes: list(Dislike.t()),
          id: Id.t(),
          amount: Amount.t(),
          owner: ShopEntity.t(),
          created: Created.t(),
          description: Description.t()
        }

  @type ok :: {
          :ok,
          ProductEntity.t()
        }

  @type error_creating :: {
          :error,
          ImpossibleCreateError.t()
          | NameIsInvalidError.t()
          | DescriptionIsInvalidError.t()
        } | UserEntity.error_authorizating()

  @type error_changing_data :: {
          :error,
          NameIsInvalidError.t()
          | DescriptionIsInvalidError.t()
          | AmountIsInvalidError.t()
          | ImpossibleUpdateError.t()
        } | UserEntity.error_authorizating()

  @type error_voting :: {
          :error,
          ImpossibleCreateError.t()
          | AlreadyExistsError.t()
        } | BuyerEntity.error_authorizating()

  @type error_deleting_image :: {
          :error,
          ImpossibleDeleteError.t()
        } | UserEntity.error_authorizating()

  @type error_adding_image :: {
          :error,
          ImageIsInvalidError.t()
          | ImpossibleUpdateError.t()
        } | UserEntity.error_authorizating()

  @spec new(AuthorizatingData.t(), CreatingData.t(), ShopEntity.t()) ::
          ok() | error_creating()
  def new(
        %AuthorizatingData{} = authorizating_dto,
        %CreatingData{} = dto,
        %ShopEntity{} = shop_entity
      ) do
    images =
      Enum.map(dto.images, fn image -> Image.new(image) end)
      |> Enum.filter(fn {result, _} -> result == :ok end)
      |> Enum.map(fn {_, value_image} -> value_image end)
      |> Enum.take(10)

    with {:ok, _} <- UserEntity.authorizate(authorizating_dto),
         {:ok, value_name} <- Name.new(dto.name),
         {:ok, value_desc} <- Description.new(dto.description),
         {:ok, value_amount} <- Amount.new(dto.amount),
         {:ok, value_image} <- Image.new(dto.logo) do
      {
        :ok,
        %ProductEntity{
          name: value_name,
          logo: value_image,
          images: images,
          likes: [],
          dislikes: [],
          id: Id.new(),
          amount: value_amount,
          owner: shop_entity,
          created: Created.new(),
          description: value_desc
        }
      }
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  def new(_, _, _) do
    ImpossibleCreateError.new("Impossible create Product for invalid data")
  end

  @spec change_data(AuthorizatingData.t(), UpdatingData.t(), ProductEntity.t()) ::
          ok() | error_changing_data()
  def change_data(
        %AuthorizatingData{} = authorizating_dto,
        %UpdatingData{} = dto,
        %ProductEntity{} = entity
      )
      when is_binary(dto.name) and is_binary(dto.description) and is_integer(dto.amount) do
    with {:ok, _} <- UserEntity.authorizate(authorizating_dto),
         {:ok, value_name} <- Name.new(dto.name),
         {:ok, value_desc} <- Description.new(dto.description),
         {:ok, value_amount} <- Amount.new(dto.amount) do
      {
        :ok,
        %ProductEntity{
          name: value_name,
          logo: entity.logo,
          images: entity.images,
          likes: entity.likes,
          dislikes: entity.dislikes,
          id: entity.id,
          amount: value_amount,
          owner: entity.owner,
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
        %ProductEntity{} = entity
      )
      when is_binary(dto.name) and is_binary(dto.description) do
    with {:ok, _} <- UserEntity.authorizate(authorizating_dto),
         {:ok, value_name} <- Name.new(dto.name),
         {:ok, value_desc} <- Description.new(dto.description) do
      {
        :ok,
        %ProductEntity{
          name: value_name,
          logo: entity.logo,
          images: entity.images,
          likes: entity.likes,
          dislikes: entity.dislikes,
          id: entity.id,
          amount: entity.amount,
          owner: entity.owner,
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
        %ProductEntity{} = entity
      )
      when is_binary(dto.name) and is_integer(dto.amount) do
    with {:ok, _} <- UserEntity.authorizate(authorizating_dto),
         {:ok, value_name} <- Name.new(dto.name),
         {:ok, value_amount} <- Amount.new(dto.amount) do
      {
        :ok,
        %ProductEntity{
          name: value_name,
          logo: entity.logo,
          images: entity.images,
          likes: entity.likes,
          dislikes: entity.dislikes,
          id: entity.id,
          amount: value_amount,
          owner: entity.owner,
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
        %ProductEntity{} = entity
      )
      when is_binary(dto.description) and is_integer(dto.amount) do
    with {:ok, _} <- UserEntity.authorizate(authorizating_dto),
         {:ok, value_desc} <- Description.new(dto.description),
         {:ok, value_amount} <- Amount.new(dto.amount) do
      {
        :ok,
        %ProductEntity{
          name: entity.name,
          logo: entity.logo,
          images: entity.images,
          likes: entity.likes,
          dislikes: entity.dislikes,
          id: entity.id,
          amount: value_amount,
          owner: entity.owner,
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
        %ProductEntity{} = entity
      )
      when is_integer(dto.amount) do
    with {:ok, _} <- UserEntity.authorizate(authorizating_dto),
         {:ok, value_amount} <- Amount.new(dto.amount) do
      {
        :ok,
        %ProductEntity{
          name: entity.name,
          logo: entity.logo,
          images: entity.images,
          likes: entity.likes,
          dislikes: entity.dislikes,
          id: entity.id,
          amount: value_amount,
          owner: entity.owner,
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
        %ProductEntity{} = entity
      )
      when is_binary(dto.description) do
    with {:ok, _} <- UserEntity.authorizate(authorizating_dto),
         {:ok, value_desc} <- Description.new(dto.description) do
      {
        :ok,
        %ProductEntity{
          name: entity.name,
          logo: entity.logo,
          images: entity.images,
          likes: entity.likes,
          dislikes: entity.dislikes,
          id: entity.id,
          amount: entity.amount,
          owner: entity.owner,
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
        %ProductEntity{} = entity
      )
      when is_binary(dto.name) do
    with {:ok, _} <- UserEntity.authorizate(authorizating_dto),
         {:ok, value_name} <- Name.new(dto.name) do
      {
        :ok,
        %ProductEntity{
          name: value_name,
          logo: entity.logo,
          images: entity.images,
          likes: entity.likes,
          dislikes: entity.dislikes,
          id: entity.id,
          amount: entity.amount,
          owner: entity.owner,
          created: entity.created,
          description: entity.description
        }
      }
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  def change_data(_, _, _) do
    ImpossibleUpdateError.new("Impossible change data of product for invalid input data")
  end

  @spec change_logo(AuthorizatingData.t(), UpdatingLogoData.t(), ProductEntity.t()) ::
          ok() | error_adding_image()
  def change_logo(
        %AuthorizatingData{} = authorizating_dto,
        %UpdatingLogoData{} = dto,
        %ProductEntity{} = entity
      ) do
    with {:ok, _} <- UserEntity.authorizate(authorizating_dto),
         {:ok, value_image} <- Image.new(dto.logo) do
      {
        :ok,
        %ProductEntity{
          name: entity.name,
          logo: value_image,
          images: entity.images,
          likes: entity.likes,
          dislikes: entity.dislikes,
          id: entity.id,
          amount: entity.amount,
          owner: entity.owner,
          created: entity.created,
          description: entity.description
        }
      }
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  def change_logo(_, _) do
    ImpossibleUpdateError.new("Impossible change logo for invalid data")
  end

  @spec delete_image(AuthorizatingData.t(), DeletingImageData.t(), ProductEntity.t()) :: ok() | error_deleting_image()
  def delete_image(%AuthorizatingData{} = authorizating_dto, %DeletingImageData{} = dto, %ProductEntity{} = entity) do
    found = Enum.find(entity.images, fn %Image{value: _, created: _, id: id} -> id == dto.id end)

    with {:ok, _} <- UserEntity.authorizate(authorizating_dto),
         true <- found != nil do

      {
        :ok,
        %ProductEntity{
          name: entity.name,
          logo: entity.logo,
          images:
            Enum.filter(entity.dislikes, fn %Image{value: _, created: _, id: id} -> id != dto.id end),
          likes: entity.likes,
          dislikes: entity.dislikes,
          id: entity.id,
          amount: entity.amount,
          owner: entity.owner,
          created: entity.created,
          description: entity.description
        }
      }
    else
      false -> {:error, ImpossibleDeleteError.new("Image not found")}
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  def delete_image(_, _, _) do
    {:error, ImpossibleDeleteError.new("Impossible delete image for invalid data")}
  end

  @spec add_image(AuthorizatingData.t(), AddingImageData.t(), ProductEntity.t()) :: ok() | error_adding_image()
  def add_image(%AuthorizatingData{} = authorizating_dto, %AddingImageData{} = dto, %ProductEntity{} = entity) do
    images =
      Enum.map(dto.images, fn image -> Image.new(image) end)
      |> Enum.filter(fn {result, _} -> result == :ok end)
      |> Enum.map(fn {_, value_image} -> value_image end)
      |> Enum.take(10)

    with {:ok, _} <- UserEntity.authorizate(authorizating_dto),
         true <- length(entity.images) < 10,
         true <- length(entity.images) + length(images) < 10 do
      {
        :ok,
        %ProductEntity{
          name: entity.name,
          logo: entity.logo,
          images: Enum.concat(entity.images, images),
          likes: entity.likes,
          dislikes: entity.dislikes,
          id: entity.id,
          amount: entity.amount,
          owner: entity.owner,
          created: entity.created,
          description: entity.description
        }
      }
    else
      {:error, error_dto} -> {:error, error_dto}
      false -> ImpossibleUpdateError.new("Image list too long")
    end
  end

  def add_image(_, _, _) do
    ImpossibleUpdateError.new("Impossible add images for invalid data")
  end

  @spec like(AuthorizatingData.t(), ProductEntity.t()) :: ok() | error_voting()
  def like(%AuthorizatingData{} = authorizating_dto, %ProductEntity{} = entity) do
    case BuyerEntity.authorizate(authorizating_dto) do
      {:error, error_dto} -> {:error, error_dto}
      {:ok, buyer_entity} ->
        found = Enum.find(entity.likes, fn %Like{value: id} -> id == buyer_entity.id end)
        with true <- found == nil,
             {:ok, value_like} <- Like.new(buyer_entity.id) do

          {
            :ok,
            %ProductEntity{
              name: entity.name,
              logo: entity.logo,
              images: entity.images,
              likes: [value_like | entity.likes],
              dislikes:
                Enum.filter(entity.dislikes, fn %Dislike{value: id} -> id != buyer_entity.id end),
              id: entity.id,
              amount: entity.amount,
              owner: entity.owner,
              created: entity.created,
              description: entity.description
            }
          }
        else
          {:error, error_dto} -> {:error, error_dto}
          false -> {:error, AlreadyExistsError.new("Buyer with this id already have liked this Shop")}
        end
    end
  end

  def like(_, _) do
    ImpossibleUpdateError.new("Impossible liking for invalid data")
  end

  @spec dislike(AuthorizatingData.t(), ProductEntity.t()) :: ok() | error_voting()
  def dislike(%AuthorizatingData{} = authorizating_dto, %ProductEntity{} = entity) do
    case BuyerEntity.authorizate(authorizating_dto) do
      {:error, error_dto} -> {:error, error_dto}
      {:ok, buyer_entity} ->
        found = Enum.find(entity.dislikes, fn %Dislike{value: id} -> id == buyer_entity.id end)
        with true <- found == nil,
             {:ok, value_dislike} <- Dislike.new(buyer_entity.id) do
          {
            :ok,
            %ProductEntity{
              name: entity.name,
              logo: entity.logo,
              images: entity.images,
              likes:
                Enum.filter(entity.likes, fn %Like{value: id} -> id != buyer_entity.id end),
              dislikes: [value_dislike | entity.dislikes],
              id: entity.id,
              amount: entity.amount,
              owner: entity.owner,
              created: entity.created,
              description: entity.description
            }
          }
        else
          {:error, error_dto} -> {:error, error_dto}
          false -> {:error, AlreadyExistsError.new("Buyer with this id already have disliked this Shop")}
        end
    end
  end

  def dislike(_, _) do
    ImpossibleUpdateError.new("Impossible disliking for invalid data")
  end
end
