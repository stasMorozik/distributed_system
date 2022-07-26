defmodule Core.ApplicationLayer.DeletingImageProductService do
  @moduledoc false

  alias Core.DomainLayer.UseCases.DeletingImageProductUseCase
  alias Core.DomainLayer.Ports.DeletingImageProductPort
  alias Core.DomainLayer.Ports.ParsingJwtPort

  @behaviour DeletingImageProductUseCase

  @spec delete(
          binary(),
          binary(),
          binary(),
          ParsingJwtPort.t(),
          DeletingImageProductPort.t()
        ) :: DeletingImageProductUseCase.ok() | DeletingImageProductUseCase.error()
  def delete(token, id_product, id_image, parsing_jwt_port, deleting_image_product_port) do
    with {:ok, _} <- parsing_jwt_port.parse(token),
         {:ok, _} <- deleting_image_product_port.delete_image(id_product, id_image) do
      {:ok, true}
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end
end
