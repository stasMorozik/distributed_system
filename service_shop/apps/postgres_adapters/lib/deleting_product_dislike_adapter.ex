defmodule PostgresAdapters.DeletingProductDislikeAdapter do
  @moduledoc false
  import Ecto.Query

  alias Shop.Repo

  alias Core.DomainLayer.Ports.DeletingProductDislikePort

  alias Core.DomainLayer.Dtos.ImpossibleDeleteError

  alias Core.DomainLayer.ValueObjects.Id

  alias Shop.DislikeSchema

  @behaviour DeletingProductDislikePort

  @spec delete(Id.t()) :: DeletingProductDislikePort.ok() | DeletingProductDislikePort.error()
  def delete(%Id{value: id}) do
    case Repo.transaction(fn ->
      from(d in DislikeSchema, where: d.owner_id == ^id) |> Repo.delete_all()
    end) do
      {:ok, _} -> {:ok, true}
      {:error, _} -> {:error, ImpossibleDeleteError.new()}
    end
  end

  def delete(_) do
    {:error, ImpossibleDeleteError.new()}
  end
end
