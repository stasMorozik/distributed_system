defmodule GettingProductAdapterimple do
  @moduledoc false

  import Ecto.Query
  alias Shop.Repo

  alias Core.DomainLayer.Ports.GettingProductPort

  alias Core.DomainLayer.Dtos.ImpossibleGetError

  alias Core.DomainLayer.Dtos.NotFoundError

  alias Shop.ProductSchema

  alias Core.DomainLayer.ValueObjects.Id
  alias Core.DomainLayer.ValueObjects.Price
  alias Core.DomainLayer.ValueObjects.Amount

  alias Core.DomainLayer.ProductAggregate

  @behaviour GettingProductPort

  @spec get(Id.t()) :: GettingProductPort.ok() | GettingProductPort.error()
  def get(%Id{value: id}) do
    with query <-
           from(
             product in ProductSchema,
             where: product.id == ^id,
             select: %{id: product.id, amount: product.amount, price: product.price}
           ),
         product_schema <- Repo.one(query),
         true <- product_schema != nil do
      {
        :ok,
        %ProductAggregate{
          id: %Id{value: product_schema.id},
          price: %Price{value: product_schema.price},
          amount: %Amount{value: product_schema.amount}
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
