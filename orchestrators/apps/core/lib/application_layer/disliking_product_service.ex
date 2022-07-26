defmodule Core.ApplicationLayer.DislikingProductService do
  @moduledoc false

  alias Core.DomainLayer.UseCases.DislikingProductUseCase
  alias Core.DomainLayer.Ports.DislikingProductPort
  alias Core.DomainLayer.Ports.ParsingJwtPort

  @behaviour DislikingProductUseCase

  @spec dislike(
          binary(),
          binary(),
          ParsingJwtPort.t(),
          DislikingProductPort.t()
        ) :: DislikingProductUseCase.ok() | DislikingProductUseCase.error()
  def dislike(token, id_product, parsing_jwt_port, disliking_product_port) do
    with {:ok, claims} <- parsing_jwt_port.parse(token),
         {:ok, _} <- disliking_product_port.dislike_product(id_product, %{email: claims.email, id: claims.id}) do
      {:ok, true}
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end
end
