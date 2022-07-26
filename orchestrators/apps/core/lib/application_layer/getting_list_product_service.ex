defmodule Core.ApplicationLayer.GettingListProductService do
  @moduledoc false

  alias Core.DomainLayer.UseCases.GettingListProductUseCase
  alias Core.DomainLayer.Ports.GettingListProductPort

  @behaviour GettingListProductUseCase

  @callback get(
              GettingListProductPort.dto_pagination(),
              GettingListProductPort.dto_sorting()    | nil,
              GettingListProductPort.dto_filtration() | nil,
              GettingListProductPort.dto_spliting()   | nil,
              GettingListProductPort.t()
            ) :: GettingListProductUseCase.ok() | GettingListProductUseCase.error()
  def get(
        dto_pagination,
        dto_sorting,
        dto_filtration,
        dto_spliting,
        getting_list_product_port
      ) do
    with {:ok, product_entities} <-
      getting_list_product_port.get_list_product(
        dto_pagination,
        dto_sorting,
        dto_filtration,
        dto_spliting
      ) do
      {:ok, product_entities}
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end
end
