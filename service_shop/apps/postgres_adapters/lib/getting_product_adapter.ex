defmodule PostgresAdapters.GettingProductAdapter do
  @moduledoc false

  import Ecto.Query
  alias Shop.Repo

  alias Core.DomainLayer.Ports.GettingProductPort

  alias Core.DomainLayer.Dtos.ImpossibleGetError

  alias Core.DomainLayer.Dtos.NotFoundError

  alias Core.DomainLayer.ValueObjects.Id
  alias Core.DomainLayer.ValueObjects.Created
  alias Core.DomainLayer.ValueObjects.Name
  alias Core.DomainLayer.ValueObjects.Amount
  alias Core.DomainLayer.ValueObjects.Description
  alias Core.DomainLayer.ValueObjects.Price
  alias Core.DomainLayer.ValueObjects.Image
  alias Core.DomainLayer.ValueObjects.Email

  alias Core.DomainLayer.ImageEntity
  alias Core.DomainLayer.OwnerEntity

  alias Core.DomainLayer.ProductAggregate

  alias Shop.ProductSchema

  alias Shop.OwnerProductSchema

  alias Shop.OwnerSchema

  alias Shop.LikeSchema

  alias Shop.DislikeSchema

  @behaviour GettingProductPort

  @spec get(Id.t()) :: GettingProductPort.ok() | GettingProductPort.error()
  def get(%Id{value: id}) do
    with query <-
           from(product in ProductSchema,
             left_join: logo in assoc(product, :logo),
             left_join: images in assoc(product, :images),
             join: owner in OwnerProductSchema,
             on: owner.product_id == product.id,
             join: true_owner in OwnerSchema,
             on: owner.owner_id == true_owner.id,
             left_join: like in LikeSchema,
             on: like.product_id == product.id,
             left_join: true_like in OwnerSchema,
             on: like.owner_id == true_like.id,
             left_join: dislike in DislikeSchema,
             on: dislike.product_id == product.id,
             left_join: true_dislike in OwnerSchema,
             on: dislike.owner_id == true_dislike.id,
             where: product.id == ^id,
             preload: [
               logo: logo,
               images: images,
               owner: true_owner,
               likes: true_like,
               dislikes: true_dislike
             ]
           ),
         product_schema <- Repo.one(query),
         true <- product_schema != nil do
      {
        :ok,
        %ProductAggregate{
          id: %Id{value: product_schema.id},
          name: %Name{value: product_schema.name},
          created: %Created{value: product_schema.created},
          amount: %Amount{value: product_schema.amount},
          ordered: %Amount{value: product_schema.ordered},
          description: %Description{value: product_schema.description},
          price: %Price{value: product_schema.price},
          logo: %ImageEntity{
            created: %Created{value: product_schema.logo.created},
            id: %Id{value: product_schema.logo.id},
            image: %Image{value: product_schema.logo.image}
          },
          images:
            Enum.map(product_schema.images, fn image ->
              %ImageEntity{
                created: %Created{value: image.created},
                id: %Id{value: image.id},
                image: %Image{value: image.image}
              }
            end),
          owner: %OwnerEntity{
            id: %Id{value: product_schema.owner.id},
            created: %Created{value: product_schema.owner.created},
            email: %Email{value: product_schema.owner.email}
          },
          likes:
            Enum.map(product_schema.likes, fn owner ->
              %OwnerEntity{
                id: %Id{value: owner.id},
                created: %Created{value: owner.created},
                email: %Email{value: owner.email}
              }
            end)
        }
      }
    else
      false -> {:error, NotFoundError.new("Product")}
    end
  end

  def get(_) do
    {:error, ImpossibleGetError.new()}
  end
end
