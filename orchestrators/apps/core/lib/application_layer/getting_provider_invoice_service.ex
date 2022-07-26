defmodule Core.ApplicationLayer.GettingProviderInvoiceService do
  @moduledoc false

  alias Core.DomainLayer.UseCases.GettingProviderInvoiceUseCase
  alias Core.DomainLayer.Ports.GettingProviderInvoicePort
  alias Core.DomainLayer.Ports.ParsingJwtPort

  @behaviour GettingProviderInvoiceUseCase

  @spec get(
          binary(),
          binary(),
          ParsingJwtPort.t(),
          GettingProviderInvoicePort.t()
        ) :: GettingProviderInvoiceUseCase.ok() | GettingProviderInvoiceUseCase.error()
  def get(token, id, parsing_jwt_port, getting_provider_invoice_port) do
    with {:ok, _} <- parsing_jwt_port.parse(token),
         {:ok, invoice_entity} <- getting_provider_invoice_port.get_provider_invoice(id) do
      {:ok, invoice_entity}
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end
end
