defmodule DeletingProductLikeAdapter do
  @moduledoc false

  import Ecto.Query

  alias Shop.Repo

  alias Core.DomainLayer.Ports.DeletingProductLikePort

  alias Core.DomainLayer.Dtos.ImpossibleDeleteError

  alias Core.DomainLayer.ValueObjects.Id

  alias Shop.LikeSchema

  @behaviour DeletingProductLikePort

  @callback delete(Id.t()) :: DeletingProductLikePort.ok() | DeletingProductLikePort.error()
  def delete(%Id{value: id}) do
    case Repo.transaction(fn ->
      from(l in LikeSchema, where: l.owner_id == ^id) |> Repo.delete_all()
    end) do
      {:ok, _} -> {:ok, true}
      {:error, _} -> {:error, ImpossibleDeleteError.new()}
    end
  end

  def delete(_) do
    {:error, ImpossibleDeleteError.new()}
  end
end
