defmodule AddingProductImageAdapter do
  @moduledoc false

  alias Shop.Repo

  alias Core.DomainLayer.Ports.AddingProductImagePort

  alias Core.DomainLayer.Dtos.ImpossibleCreateError

  alias Core.DomainLayer.ImageEntity

  alias Core.DomainLayer.ValueObjects.Id

  alias Shop.ImageShema

  @behaviour AddingProductImagePort

  @spec add(Id.t(), list(ImageEntity.t())) :: AddingProductImagePort.ok() | AddingProductImagePort.error()
  def add(%Id{} = value_id, list_images) when is_list(list_images) do
    list_changesets =  Enum.map(list_images, fn image_entity -> %ImageShema{} |> ImageShema.changeset(%{
      id: image_entity.id.value,
      created: image_entity.created.value,
      image: image_entity.image.value,
      product_id: value_id.value,
    }) end)


    case Repo.transaction(fn ->
      Enum.each(list_changesets, &Repo.insert(&1, []))
    end)  do
      {:ok, _} -> {:ok, true}
      {:error, _} -> {:error, ImpossibleCreateError.new()}
    end
  end

  def add(_) do
    {:error, ImpossibleCreateError.new()}
  end
end
