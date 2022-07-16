defmodule Core.ApplicationLayer.UpdatingProviderInvoiceStatusService do
  @moduledoc false

  alias Core.DomainLayer.UseCases.UpdatingProviderInvoiceStatusUseCase

  alias Core.DomainLayer.Ports.UpdatingProviderInvoicePort

  alias Core.DomainLayer.Ports.GettingProviderInvoicePort

  alias Core.DomainLayer.ProviderInvoiceAggregate

  alias Core.DomainLayer.ValueObjects.Id

  @behaviour UpdatingProviderInvoiceStatusUseCase

  @callback update(
              binary(),
              GettingProviderInvoicePort.t(),
              UpdatingProviderInvoicePort.t()
            ) :: UpdatingProviderInvoiceStatusUseCase.ok() | UpdatingProviderInvoiceStatusUseCase.error()
  def update(
        maybe_id,
        getting_provider_invoice_port,
        updating_provider_invoice_port
      ) do
    with {:ok, value_id} <- Id.from_origin(maybe_id),
         {:ok, entity_invoice} <- getting_provider_invoice_port.get(value_id),
         {:ok, entity_invoice} <- ProviderInvoiceAggregate.change_status(entity_invoice),
         {:ok, true} <- updating_provider_invoice_port.update(entity_invoice) do
      {:ok, true}
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end
end
