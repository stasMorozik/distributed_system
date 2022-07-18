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

  @behaviour GettingProductPort

  @spec get(Id.t()) :: GettingProductPort.ok() | GettingProductPort.error()
  def get(%Id{value: id}) do
    with {:ok, _} <- UUID.info(id),
         query <-
          from(p in ProductSchema,
            join: l in assoc(p, :logo),
            join: i in assoc(p, :images),
            join: owner in OwnerProductSchema,
              on: owner.product_id == p.id,
              join: true_owner in OwnerSchema,
                on: owner.owner_id == true_owner.id,
            where: p.id == ^id,
            preload: [logo: l, images: i, owner: true_owner]
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
          images: Enum.map(product_schema.images, fn image -> %ImageEntity{
            created: %Created{value: image.created},
            id: %Id{value: image.id},
            image: %Image{value: image.image}
          } end),
          owner: %OwnerEntity{
            id: %Id{value: product_schema.owner.id},
            created: %Created{value: product_schema.owner.created},
            email: %Email{value: product_schema.owner.email}
          }
        }
      }
    else
      false -> {:error, NotFoundError.new("Product")}
      {:error, _} -> {:error, ImpossibleGetError.new()}
    end
  end

  def get() do
    {:error, ImpossibleGetError.new()}
  end
end
