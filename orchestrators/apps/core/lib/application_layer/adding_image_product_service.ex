defmodule Core.ApplicationLayer.AddingImageProductService do
  @moduledoc false

  alias Core.DomainLayer.UseCases.AddingImageProductUseCase
  alias Core.DomainLayer.Ports.AddingImageProductPort
  alias Core.DomainLayer.Ports.ParsingJwtPort

  @behaviour AddingImageProductUseCase

  @spec add(
          binary(),
          binary(),
          list(binary()),
          ParsingJwtPort.t(),
          AddingImageProductPort.t()
        ) :: AddingImageProductUseCase.ok() | AddingImageProductUseCase.error()
  def add(token, id, list_image, parsing_jwt_port, adding_image_product_port) do
    with {:ok, _} <- parsing_jwt_port.parse(token),
         {:ok, _} <- adding_image_product_port.add_image(id, list_image) do
      {:ok, true}
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end
end
