defmodule Core.ApplicationLayer.CreatingProductService do
  @moduledoc false

  alias Core.DomainLayer.UseCases.CreatingProductUseCase
  alias Core.DomainLayer.Ports.CreatingProductPort
  alias Core.DomainLayer.Ports.ParsingJwtPort

  @behaviour CreatingProductUseCase

  @spec create(
          binary(),
          CreatingProductUseCase.creating_dto(),
          ParsingJwtPort.t(),
          CreatingProductPort.t()
        ) :: CreatingProductUseCase.ok() | CreatingProductUseCase.error()
  def create(token, dto, parsing_jwt_port, creating_product_port) do
    with {:ok, claims} <- parsing_jwt_port.parse(token),
         {:ok, _} <- creating_product_port.create_product(%{
          name: dto[:name],
          amount: dto[:amount],
          description: dto[:description],
          price: dto[:price],
          logo: dto[:logo],
          images: dto[:images],
          owner: %{
            id: claims.id,
            email: claims.email
          }
        }) do
      {:ok, true}
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end
end
