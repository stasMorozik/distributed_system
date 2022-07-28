defmodule Core.ApplicationLayer.GettingListProductService do
  @moduledoc false

  alias Core.DomainLayer.UseCases.GettingListProductUseCase

  alias Core.DomainLayer.Ports.GettingListProductPort

  alias Core.DomainLayer.ValueObjects.SortingProducts

  alias Core.DomainLayer.ValueObjects.SplitingProducts

  alias Core.DomainLayer.ValueObjects.Sorting

  alias Core.DomainLayer.ValueObjects.Splitting

  alias Core.DomainLayer.ValueObjects.Pagination

  alias Core.DomainLayer.ValueObjects.FiltrationProducts

  @behaviour GettingListProductUseCase

  @callback get(
              Pagination.creating_dto(),
              Sorting.creating_dto()                     | nil,
              GettingListProductUseCase.dto_filtration() | nil,
              Splitting.creating_dto()                   | nil,
              GettingListProductPort.t()
            ) :: GettingListProductUseCase.ok() | GettingListProductUseCase.error()
  def get(
        dto_pagination,
        maybe_dto_sorting,
        maybe_dto_filtration,
        maybe_dto_spliting,
        getting_list_product_port
      ) do
    IO.inspect(dto_pagination)
    IO.inspect(maybe_dto_sorting)
    IO.inspect(maybe_dto_filtration)
    IO.inspect(maybe_dto_spliting)
    with {:ok, value_pagination} <- Pagination.new(dto_pagination),
         {:ok, value_sorting} <- define_sorting(maybe_dto_sorting),
         {:ok, value_filtration} <- define_filtration(maybe_dto_filtration),
         {:ok, value_spliting} <- define_spliting(maybe_dto_spliting),
         {:ok, list_product_entity} <- getting_list_product_port.get(
           value_pagination,
           value_sorting,
           value_filtration,
           value_spliting
          ) do
      {:ok, list_product_entity}
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  defp define_sorting(dto_sorting) do
    with false <- dto_sorting == nil,
         {:ok, value_sorting} <- SortingProducts.new(dto_sorting) do
      {:ok, value_sorting}
    else
      true -> {:ok, nil}
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  defp define_filtration(dto_filtration) do
    with false <- dto_filtration == nil,
         {:ok, value_filtration} <- FiltrationProducts.new(dto_filtration) do
      {:ok, value_filtration}
    else
      true -> {:ok, nil}
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  defp define_spliting(dto_spliting) do
    with false <- dto_spliting == nil,
         {:ok, value_spliting} <- SplitingProducts.new(dto_spliting) do
      {:ok, value_spliting}
    else
      true -> {:ok, nil}
      {:error, error_dto} -> {:error, error_dto}
    end
  end
end
