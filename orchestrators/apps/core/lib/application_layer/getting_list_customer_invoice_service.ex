defmodule Core.ApplicationLayer.GettingListCustomerInvoiceService do
  @moduledoc false

  alias Core.DomainLayer.UseCases.GettingListCustomerInvoiceUseCase
  alias Core.DomainLayer.Ports.GettingLIstCustomerInvoicePort
  alias Core.DomainLayer.Ports.ParsingJwtPort

  @behaviour GettingListCustomerInvoiceUseCase

  @spec get(
          binary(),
          GettingLIstCustomerInvoicePort.dto_pagination(),
          GettingLIstCustomerInvoicePort.dto_sorting()    | nil,
          GettingLIstCustomerInvoicePort.dto_filtration() | nil,
          GettingLIstCustomerInvoicePort.dto_spliting()   | nil,
          ParsingJwtPort.t(),
          GettingLIstCustomerInvoicePort.t()
        ) :: GettingListCustomerInvoiceUseCase.ok() | GettingListCustomerInvoiceUseCase.error()
  def get(
        token,
        dto_pagination,
        dto_sorting,
        dto_filtration,
        dto_spliting,
        parsing_jwt_port,
        getting_list_customer_invoice_port
      ) do
    case dto_filtration != nil && is_map(dto_filtration) do
      true ->
        with {:ok, claims} <- parsing_jwt_port.parse(token),
             {:ok, invoice_entities} <-
              getting_list_customer_invoice_port.get_list_customer_invoice(
                dto_pagination,
                dto_sorting,
                %{customer: claims.email, provider: dto_filtration[:provider]},
                dto_spliting
              ) do
          {:ok, invoice_entities}
        else
          {:error, error_dto} -> {:error, error_dto}
        end

      false ->
        with {:ok, claims} <- parsing_jwt_port.parse(token),
             {:ok, invoice_entities} <-
              getting_list_customer_invoice_port.get_list_customer_invoice(
                dto_pagination,
                dto_sorting,
                %{customer: claims.email},
                dto_spliting
              ) do
          {:ok, invoice_entities}
        else
          {:error, error_dto} -> {:error, error_dto}
        end
    end
  end
end
