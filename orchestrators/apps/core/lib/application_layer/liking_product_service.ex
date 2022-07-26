defmodule Core.ApplicationLayer.LikingProductService do
  @moduledoc false

  alias Core.DomainLayer.UseCases.LikingProductUseCase
  alias Core.DomainLayer.Ports.LikingProductPort
  alias Core.DomainLayer.Ports.ParsingJwtPort

  @behaviour LikingProductUseCase

  @spec like(
          binary(),
          binary(),
          ParsingJwtPort.t(),
          LikingProductPort.t()
        ) :: LikingProductUseCase.ok() | LikingProductUseCase.error()
  def like(token, id, parsing_jwt_port, liking_product_port) do
    with {:ok, claims} <- parsing_jwt_port.parse(token),
         {:ok, _} <- liking_product_port.like_product(id, %{email: claims.email, id: claims.id}) do
      {:ok, true}
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end
end
