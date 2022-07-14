defmodule Core.ApplicationLayer.DeletingProductImageService do
  @moduledoc false

  alias Core.DomainLayer.UseCases.DeletingProductImageUseCase

  alias Core.DomainLayer.Ports.DeletingProductImagePort

  alias Core.DomainLayer.ProductAggregate

  alias Core.DomainLayer.ValueObjects.Id

  @behaviour DeletingProductImageUseCase

  @spec delete(
    binary(),
    binary(),
    GettingProductPort.t(),
    DeletingProductImagePort.t()
  ) :: DeletingProductImageUseCase.ok() | DeletingProductImageUseCase.error()
  def delete(maybe_product_id, maybe_image_id, getting_product_port, deleting_product_image_port) do
    with {:ok, value_product_id} <- Id.from_origin(maybe_product_id),
         {:ok, value_image_id} <- Id.from_origin(maybe_image_id),
         {:ok, product_entity} <- getting_product_port.get(value_product_id),
         {:ok, _} <- ProductAggregate.delete_image(product_entity, value_image_id),
         {:ok, true} <- deleting_product_image_port.delete(value_image_id) do
      {:ok, true}
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end
end
