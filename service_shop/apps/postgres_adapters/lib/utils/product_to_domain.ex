defmodule PostgresAdapters.Utils.ProductToDomain do
  @moduledoc false

  alias Core.DomainLayer.ProductAggregate

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

  def from_list_splitting(list_splitting_product) do
    Enum.map(list_splitting_product, fn {product, like_count, dislike_count, _} ->
      to(product, like_count, dislike_count)
    end)
  end

  def from_list(list_product) do
    Enum.map(list_product, fn {product, like_count, dislike_count} ->
      to(product, like_count, dislike_count)
    end)
  end

  def to(product_schema, like_count, dislike_count) do
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
        case is_list(product_schema.images) do
          true ->
            Enum.map(product_schema.images, fn image ->
              %ImageEntity{
                created: %Created{value: image.created},
                id: %Id{value: image.id},
                image: %Image{value: image.image}
              }
            end)

          _ ->
            []
        end,
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
        end),
      like_count: %Amount{value: like_count.count},
      dislike_count: %Amount{value: dislike_count.count}
    }
  end
end
