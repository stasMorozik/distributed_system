defmodule GettingProductAdapter do
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
  alias Utils.ProductToDomain

  @behaviour GettingProductPort

  @spec get(Id.t()) :: GettingProductPort.ok() | GettingProductPort.error()
  def get(%Id{value: id}) do
    query =
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
        ],
        select: {
          product,
          %{count: fragment("count(?) as like_count", true_like)},
          %{count: fragment("count(?) as dislike_count", true_dislike)}
        },
        group_by: [true_dislike.id, true_like.id, true_owner.id, images.id, product.id, logo.id]
      )

    case Repo.one(query) do
      nil ->
        {:error, NotFoundError.new("Product")}

      {product_schema, like_count, dislike_count} ->
        {
          :ok,
          ProductToDomain.to(product_schema, like_count, dislike_count)
        }
    end
  end

  def get(_) do
    {:error, ImpossibleGetError.new()}
  end
end
