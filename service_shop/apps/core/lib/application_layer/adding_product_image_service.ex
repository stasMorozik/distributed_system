defmodule Core.ApplicationLayer.AddingProductImageService do
  @moduledoc false

  alias Core.DomainLayer.UseCases.AddingProductImageUseCase

  alias Core.DomainLayer.Ports.AddingProductImagePort

  alias Core.DomainLayer.Ports.GettingProductPort

  alias Core.DomainLayer.ValueObjects.Id

  alias Core.DomainLayer.ImageEntity

  alias Core.DomainLayer.ProductAggregate

  @behaviour AddingProductImageUseCase

  @callback add(
              binary(),
              list(binary()),
              GettingProductPort.t(),
              AddingProductImagePort.t()
            ) :: AddingProductImageUseCase.ok() | AddingProductImageUseCase.error()
  def add(
    maybe_id,
    list_binary,
    getting_product_port,
    adding_product_image_port
  ) do
    with {:ok, value_id} <- Id.from_origin(maybe_id),
         list_image_entity = Enum.map(list_binary, fn image -> ImageEntity.new(image) end),
         nil <- Enum.find(list_image_entity, fn {result, _} -> result == :error end),
         list_image_entity <- Enum.map(list_image_entity, fn {_, image_entity} -> image_entity end),
         {:ok, product_entity} <- getting_product_port.get(value_id),
         {:ok, _} <- ProductAggregate.add_image(product_entity, list_image_entity),
         {:ok, true} <- adding_product_image_port.add(list_image_entity) do
      {:ok, true}
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end
end
