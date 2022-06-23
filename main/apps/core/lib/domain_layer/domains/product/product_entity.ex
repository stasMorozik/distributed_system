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

  alias Core.DomainLayer.Common.Dtos.ImpossibleUpdateError
  alias Core.DomainLayer.Common.Dtos.ImpossibleCreateError
  alias Core.DomainLayer.Common.Dtos.NameIsInvalidError

  alias Core.DomainLayer.Domains.Product.Dtos.CreatingData

  alias Core.DomainLayer.Domains.Shop.ShopEntity


  defstruct name: nil,
            images: nil,
            likes: nil,
            dislikes: nil,
            id: nil,
            amount: nil,
            owner: nil,
            created: nil

  @type t :: %ProductEntity{
          name: binary(),
          images: list(Image.t()),
          likes: list(Like.t()),
          dislikes: list(Dislike.t())
          id: Id.t(),
          amount: Amount.t(),
          owner: ShopEntity.t(),
          created: Created.t()
        }

  @type ok :: {
          :ok,
          ProductEntity.t()
        }

  @type error_creating :: {
          :error,
          ImpossibleCreateError.t()
          | NameIsInvalidError.t()
        }

  @spec new(CreatingData.t(), ShopEntity.t()) :: ok() | error_creating()
  def new(%CreatingData{} = dto, %ShopEntity{} = shop_entity) do
    case Name.new(dto.name) do
      {:error, error_dto} ->

        {:error, error_dto}

      {:ok, value_name} ->

        {
          :ok,
          %ProductEntity{
            name: value_name,
            images: Enum.map(dto.images, fn image -> %Image{value: image} end),
            likes: [],
            dislikes: [],
            id: Id.new(),
            amount: Amount.new(0),
            owner: shop_entity,
            created: Created.new()
          }
        }
    end
  end

  def new(_, _) do
    ImpossibleCreateError.new("Impossible create Product for invalid data")
  end
end
