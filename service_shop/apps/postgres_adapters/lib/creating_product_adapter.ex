defmodule PostgresAdapters.CreatingProductAdapter do
  @moduledoc false

  alias Ecto.Multi
  alias Shop.Repo

  alias Core.DomainLayer.Ports.CreatingProductPort

  alias Core.DomainLayer.Dtos.ImpossibleCreateError

  alias Core.DomainLayer.ProductAggregate

  alias Shop.ProductSchema

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
      owner: %{
        owner_id: entity.owner.id.value,
        product_id: entity.id.value,
      },
      logo: %{
        id: entity.logo.id.value,
        image: entity.logo.image.value,
        created: entity.logo.created.value,
        product_id: entity.id.value
      },
      images: Enum.map(entity.images, fn entity_image -> %{
        id: entity_image.id.value,
        image: entity_image.image.value,
        created: entity_image.created.value,
        product_id: entity.id.value
      } end)
    })

    case Multi.new()
         |> Multi.insert(:owners, changeset_owner, on_conflict: :nothing, conflict_target: :email)
         |> Multi.insert(:products, changeset_product, on_conflict: :nothing)
         |> Repo.transaction() do
      {:ok, _} -> {:ok, true}
      {:error, _} -> {:error, ImpossibleCreateError.new()}
    end
  end

  def new(_) do
    {:error, ImpossibleCreateError.new()}
  end
end
