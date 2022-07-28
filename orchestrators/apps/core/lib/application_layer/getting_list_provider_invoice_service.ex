defmodule Core.ApplicationLayer.GettingListProviderInvoiceService do
  @moduledoc false

  alias Core.DomainLayer.UseCases.GettingListProviderInvoiceUseCase
  alias Core.DomainLayer.Ports.GettingListProviderInvoicePort
  alias Core.DomainLayer.Ports.ParsingJwtPort

  @behaviour GettingListProviderInvoiceUseCase

  @spec get(
          binary(),
          GettingListProviderInvoicePort.dto_pagination(),
          GettingListProviderInvoicePort.dto_sorting()    | nil,
          GettingListProviderInvoicePort.dto_filtration() | nil,
          GettingListProviderInvoicePort.dto_spliting()   | nil,
          ParsingJwtPort.t(),
          GettingListProviderInvoicePort.t()
        ) :: GettingListProviderInvoiceUseCase.ok() | GettingListProviderInvoiceUseCase.error()
  def get(
        token,
        dto_pagination,
        dto_sorting,
        dto_filtration,
        dto_spliting,
        parsing_jwt_port,
        getting_list_provider_invoice_port
      ) do

    case dto_filtration != nil && is_map(dto_filtration) do
      true ->
        with {:ok, claims} <- parsing_jwt_port.parse(token),
             {:ok, invoice_entities} <-
              getting_list_provider_invoice_port.get_list_provider_invoice(
                dto_pagination,
                dto_sorting,
                %{provider: claims.email, customer: dto_filtration[:customer]},
                dto_spliting
              ) do
          {:ok, invoice_entities}
        else
          {:error, error_dto} -> {:error, error_dto}
        end

      false ->
        with {:ok, claims} <- parsing_jwt_port.parse(token),
             {:ok, invoice_entities} <-
              getting_list_provider_invoice_port.get_list_provider_invoice(
                dto_pagination,
                dto_sorting,
                %{provider: claims.email},
                dto_spliting
              ) do
          {:ok, invoice_entities}
        else
          {:error, error_dto} -> {:error, error_dto}
        end
    end
  end
end
