defmodule PostgresAdapters.CreatingProductAdapters do
  @moduledoc false

  alias Ecto.Multi
  import Ecto.Query
  alias Shop.Repo

  alias Core.DomainLayer.Ports.CreatingProductPort

  alias Core.DomainLayer.Dtos.ImpossibleCreateError

  alias Core.DomainLayer.ProductAggregate

  alias Shop.ProductSchema

  alias Shop.OwnerProductSchema

  alias Shop.OwnerSchema

  @behaviour CreatingProductPort

  @spec create(ProductAggregate.t()) :: CreatingProductPort.ok() | CreatingProductPort.error()
  def create(%ProductAggregate{} = entity) do
    changeset_owner = %OwnerSchema{} |> OwnerSchema.changeset(%{
      id: entity.owner.id.value,
      email: entity.owner.email.value,
      created: entity.owner.created.value
    })

    changeset_product = %ProductSchema{} |> ProductSchema.changeset(%{
      id: entity.id.value,
      name: entity.name.value,
      created: entity.created.value,
      amount: entity.amount.value,
      ordered: entity.ordered.value,
      description: entity.description.value,
      price: entity.price.value,
      logo: entity.logo.image.value
    })

    changeset_owner_product = %OwnerProductSchema{} |> OwnerProductSchema.changeset(%{
      owner_id: entity.owner.id.value,
      product_id: entity.id.value
    })

    case Multi.new()
         |> Multi.insert(:owners, changeset_owner, on_conflict: :nothing, conflict_target: :email)
         |> Multi.insert(:products, changeset_product)
         |> Multi.insert(:owner_products, changeset_owner_product)
         |> Repo.transaction() do
      {:ok, _} -> {:ok, true}
      {:error, _} -> {:error, ImpossibleCreateError.new()}
    end
  end

  def new(_) do
    {:error, ImpossibleCreateError.new()}
  end
end
