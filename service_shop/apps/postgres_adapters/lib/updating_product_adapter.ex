defmodule UpdatingProductAdapter do
  @moduledoc false

  alias Ecto.Multi
  alias Shop.Repo

  alias Core.DomainLayer.Ports.UpdatingProductPort

  alias Core.DomainLayer.Dtos.ImpossibleUpdateError

  alias Core.DomainLayer.ProductAggregate

  alias Shop.ProductSchema

  alias Shop.LogoSchema

  @behaviour UpdatingProductPort

  @spec update(ProductAggregate.t()) :: UpdatingProductPort.ok() | UpdatingProductPort.error()
  def update(%ProductAggregate{} = entity) do
    changeset_product = %ProductSchema{id: entity.id.value} |> ProductSchema.update_changeset(%{
      name: entity.name.value,
      amount: entity.amount.value,
      ordered: entity.ordered.value,
      description: entity.description.value,
      price: entity.price.value
    })

    changeset_logo = %LogoSchema{id: entity.logo.id.value} |> LogoSchema.update_changeset(%{
      image: entity.logo.image.value
    })

    case Multi.new()
         |> Multi.update(:products, changeset_product)
         |> Multi.update(:logos, changeset_logo)
         |> Repo.transaction() do
      {:ok, _} -> {:ok, true}
      {:error, _} -> {:error, ImpossibleUpdateError.new()}
    end
  end

  def update(_) do
    {:error, ImpossibleUpdateError.new()}
  end
end
