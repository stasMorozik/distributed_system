defmodule PostgresAdapters.GettingProductAdapter do
  @moduledoc false

  import Ecto.Query
  alias Shop.Repo

  alias Core.DomainLayer.Ports.GettingProductPort

  alias Core.DomainLayer.Dtos.ImpossibleGetError

  alias Core.DomainLayer.Dtos.NotFoundError

  alias Core.DomainLayer.ValueObjects.Id

  alias Shop.ProductSchema

  alias Shop.OwnerProductSchema

  alias Shop.OwnerSchema

  alias Shop.LikeSchema

  alias Shop.DislikeSchema

  alias PostgresAdapters.Utils.ProductToDomain

  @behaviour GettingProductPort

  @spec get(Id.t()) :: GettingProductPort.ok() | GettingProductPort.error()
  def get(%Id{value: id}) do
    with query <-
           from(product in ProductSchema,
             left_join: logo in assoc(product, :logo),
             group_by: [product.id, logo.id],
             left_join: images in assoc(product, :images),
             group_by: [product.id, images.id],
             join: owner in OwnerProductSchema,
             on: owner.product_id == product.id,
             join: true_owner in OwnerSchema,
             on: owner.owner_id == true_owner.id,
             group_by: [product.id, true_owner.id],
             left_join: like in LikeSchema,
             on: like.product_id == product.id,
             left_join: true_like in OwnerSchema,
             on: like.owner_id == true_like.id,
             group_by: [product.id, true_like.id],
             left_join: dislike in DislikeSchema,
             on: dislike.product_id == product.id,
             left_join: true_dislike in OwnerSchema,
             on: dislike.owner_id == true_dislike.id,
             group_by: [product.id, true_dislike.id],
             where: product.id == ^id,
             preload: [
               logo: logo,
               images: images,
               owner: true_owner,
               likes: true_like,
               dislikes: true_dislike
             ],
             select: {
               product,
               %{count: fragment("count(?) as like_count", true_like)},
               %{count: fragment("count(?) as true_dislike", true_dislike)}
             }
           ),
         {product_schema, like_count, dislike_count} <- Repo.one(query),
         true <- product_schema != nil do
      {
        :ok,
        ProductToDomain.to(product_schema, like_count, dislike_count)
      }
    else
      false -> {:error, NotFoundError.new("Product")}
    end
  end

  def get(_) do
    {:error, ImpossibleGetError.new()}
  end
end
