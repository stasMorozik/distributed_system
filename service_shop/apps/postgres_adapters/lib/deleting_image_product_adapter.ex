defmodule PostgresAdapters.DeletingImageProductAdapter do
  @moduledoc false

  import Ecto.Query

  alias Shop.Repo

  alias Core.DomainLayer.Ports.DeletingProductImagePort

  alias Core.DomainLayer.Dtos.ImpossibleDeleteError

  alias Core.DomainLayer.ValueObjects.Id

  alias Shop.ImageShema

  @behaviour DeletingProductImagePort

  @spec delete(Id.t()) :: DeletingProductImagePort.ok() | DeletingProductImagePort.error()
  def delete(%Id{value: id}) do
    case UUID.info(id) do
      {:error, _} -> {:error, ImpossibleDeleteError.new()}
      {:ok, _} ->
        case Repo.transaction(fn ->
          from(i in ImageShema, where: i.id == ^id) |> Repo.delete_all()
        end) do
          {:ok, _} -> {:ok, true}
          {:error, _} -> {:error, ImpossibleDeleteError.new()}
        end
    end
  end

  def delete(_) do
    {:error, ImpossibleDeleteError.new()}
  end
end
