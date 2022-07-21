defmodule GettingProductAdapterimple do
  @moduledoc false

  import Ecto.Query
  alias Shop.Repo

  alias Core.DomainLayer.Ports.GettingProductPort

  alias Core.DomainLayer.Dtos.ImpossibleGetError

  alias Core.DomainLayer.Dtos.NotFoundError

  alias Shop.ProductSchema

  alias Core.DomainLayer.OwnerEntity

  alias Core.DomainLayer.ValueObjects.Id
  alias Core.DomainLayer.ValueObjects.Price
  alias Core.DomainLayer.ValueObjects.Amount
  alias Core.DomainLayer.ValueObjects.Email

  alias Core.DomainLayer.ProductAggregate

  alias Shop.OwnerProductSchema

  alias Shop.OwnerSchema

  @behaviour GettingProductPort

  @spec get(Id.t()) :: GettingProductPort.ok() | GettingProductPort.error()
  def get(%Id{value: id}) do
    with query <-
           from(
             product in ProductSchema,
             join: owner in OwnerProductSchema,
             on: owner.product_id == product.id,
             join: true_owner in OwnerSchema,
             on: owner.owner_id == true_owner.id,
             where: product.id == ^id,
             preload: [
              owner: true_owner,
            ]
           ),
         product_schema <- Repo.one(query),
         true <- product_schema != nil do
      {
        :ok,
        %ProductAggregate{
          id: %Id{value: product_schema.id},
          price: %Price{value: product_schema.price},
          amount: %Amount{value: product_schema.amount},
          owner: %OwnerEntity{
            id: %Id{value: product_schema.owner.id},
            email: %Email{value: product_schema.owner.email}
          },
        }
      }
    else
      false -> {:error, NotFoundError.new("Product")}
    end
  end

  def get() do
    {:error, ImpossibleGetError.new()}
  end
end
