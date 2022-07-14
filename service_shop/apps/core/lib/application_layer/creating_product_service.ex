defmodule Core.ApplicationLayer.CreatingProductService do
  @moduledoc false

  alias Core.DomainLayer.UseCases.CreatingProductUseCase

  alias Core.DomainLayer.Ports.CreatingProductPort

  alias Core.DomainLayer.ProductAggregate

  @behaviour CreatingProductUseCase

  @spec create(
          ProductAggregate.creating_dto(),
          CreatingProductPort.t()
        ) :: CreatingProductUseCase.ok() | CreatingProductUseCase.error()
  def create(%{} = dto, creating_product_port) do
    with {:ok, product_entity} <- ProductAggregate.new(dto),
         {:ok, true} <- creating_product_port.create(product_entity) do
      {:ok, true}
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end
end
