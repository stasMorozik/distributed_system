defmodule Core.ApplicationLayer.UpdatingStatusProviderInvoiceService do
  @moduledoc false

  alias Core.DomainLayer.UseCases.UpdatingStatusProviderInvoiceUseCase
  alias Core.DomainLayer.Ports.UpdatingStatusProviderInvoicePort
  alias Core.DomainLayer.Ports.ParsingJwtPort

  @behaviour UpdatingStatusProviderInvoiceUseCase

  @spec update(
          binary(),
          binary(),
          ParsingJwtPort.t(),
          UpdatingStatusProviderInvoicePort.t()
        ) :: UpdatingStatusProviderInvoiceUseCase.ok() | UpdatingStatusProviderInvoiceUseCase.error()
  def update(token, id, parsing_jwt_port, updating_status_provider_invoice_port) do
    with {:ok, _} <- parsing_jwt_port.parse(token),
          {:ok, _} <- updating_status_provider_invoice_port.update_status_provider_invoice(id) do
      {:ok, true}
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end
end
