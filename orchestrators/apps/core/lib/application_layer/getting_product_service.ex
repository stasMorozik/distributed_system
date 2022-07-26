defmodule Core.ApplicationLayer.GettingProductService do
  @moduledoc false

  alias Core.DomainLayer.UseCases.GettingProductUseCase
  alias Core.DomainLayer.Ports.GettingProductPort

  @behaviour GettingProductUseCase

  @spec get(
          binary(),
          GettingProductPort.t()
        ) :: GettingProductUseCase.ok() | GettingProductUseCase.error()
  def get(id, getting_product_port) do
    with {:ok, product_entity} <- getting_product_port.get_product(id) do
      {:ok, product_entity}
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end
end
