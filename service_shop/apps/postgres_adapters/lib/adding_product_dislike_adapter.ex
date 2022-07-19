defmodule PostgresAdapters.AddingProductDislikeAdapter do
  @moduledoc false

  import Ecto.Query

  alias Ecto.Multi

  alias Shop.Repo

  alias Core.DomainLayer.Ports.AddingProductDislikePort

  alias Core.DomainLayer.Dtos.ImpossibleCreateError

  alias Core.DomainLayer.OwnerEntity

  alias Core.DomainLayer.ValueObjects.Id

  alias Shop.LikeSchema

  alias Shop.DislikeSchema

  alias Shop.OwnerSchema

  @spec add(Id.t(), OwnerEntity.t()) :: AddingProductDislikePort.ok() | AddingProductDislikePort.error()
  def add(%Id{} = value_id, %OwnerEntity{} = entity) do
    changeset_owner = %OwnerSchema{} |> OwnerSchema.changeset(%{
      id: entity.id.value,
      email: entity.email.value,
      created: entity.created.value
    })

    changeset_like = %DislikeSchema{} |> DislikeSchema.changeset(%{
      product_id: value_id.value,
      owner_id: entity.id.value
    })

    q = from(l in LikeSchema, where: l.owner_id == ^entity.id.value)

    case Multi.new()
         |> Multi.insert(:owners, changeset_owner, on_conflict: :nothing, conflict_target: :email)
         |> Multi.insert(:dislikes, changeset_like)
         |> Multi.delete_all(:likes, q)
         |> Repo.transaction() do
      {:ok, _} -> {:ok, true}
      {:error, _} -> {:error, ImpossibleCreateError.new()}
    end
  end

  def add(_, _) do
    {:error, ImpossibleCreateError.new()}
  end
end
