defmodule Core.ApplicationLayer.GettingProductService do
  @moduledoc false

  alias Core.DomainLayer.UseCases.GettingProductUseCase

  alias Core.DomainLayer.Ports.GettingProductPort

  alias Core.DomainLayer.ValueObjects.Id

  @behaviour GettingProductUseCase

  @spec get(binary(), GettingProductPort.t()) :: GettingProductUseCase.ok() | GettingProductUseCase.elem()
  def get(maybe_id, getting_product_port) do
    with {:ok, value_id} <- Id.from_origin(maybe_id),
         {:ok, product_entity} <- getting_product_port.get(value_id) do
      {:ok, product_entity}
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end
end
