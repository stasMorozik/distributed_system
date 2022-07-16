defmodule Core.ApplicationLayer.GettingListProviderInvoiceService do
  @moduledoc false

  alias Core.DomainLayer.UseCases.GettingListProviderInvoiceUseCase

  alias Core.DomainLayer.ValueObjects.Pagination

  alias Core.DomainLayer.ValueObjects.FiltrationProviderInvoices

  alias Core.DomainLayer.ValueObjects.SortingProviderInvoices

  alias Core.DomainLayer.ValueObjects.SplitingProviderInvoices

  alias Core.DomainLayer.Ports.GettingListProviderInvoicePort

  alias Core.DomainLayer.ValueObjects.Sorting

  alias Core.DomainLayer.ValueObjects.Splitting

  alias Core.DomainLayer.ValueObjects.Pagination

  @spec get(
              Pagination.creating_dto(),
              Sorting.creating_dto() | nil,
              GettingListProviderInvoiceUseCase.dto_filtration() | nil,
              Splitting.creating_dto() | nil,
              GettingListProviderInvoicePort.t()
            ) :: GettingListProviderInvoiceUseCase.ok() | GettingListProviderInvoiceUseCase.error()
  def get(
        dto_pagination,
        maybe_dto_sorting,
        maybe_dto_filtration,
        maybe_dto_spliting,
        getting_list_provider_invoice_port
      ) do
    with {:ok, value_pagination} <- Pagination.new(dto_pagination),
      {:ok, value_sorting} <- define_sorting(maybe_dto_sorting),
      {:ok, value_filtration} <- define_filtration(maybe_dto_filtration),
      {:ok, value_spliting} <- define_spliting(maybe_dto_spliting),
      {:ok, list_provider_invoice_entity} <- getting_list_provider_invoice_port.get(
        value_pagination,
        value_sorting,
        value_filtration,
        value_spliting
      ) do
      {:ok, list_provider_invoice_entity}
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  defp define_sorting(dto_sorting) do
    with false <- dto_sorting == nil,
         {:ok, value_sorting} <- SortingProviderInvoices.new(dto_sorting) do
      {:ok, value_sorting}
    else
      true -> {:ok, nil}
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  defp define_filtration(dto_filtration) do
    with false <- dto_filtration == nil,
         {:ok, value_filtration} <- FiltrationProviderInvoices.new(dto_filtration) do
      {:ok, value_filtration}
    else
      true -> {:ok, nil}
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  defp define_spliting(dto_spliting) do
    with false <- dto_spliting == nil,
         {:ok, value_spliting} <- SplitingProviderInvoices.new(dto_spliting) do
      {:ok, value_spliting}
    else
      true -> {:ok, nil}
      {:error, error_dto} -> {:error, error_dto}
    end
  end
end
