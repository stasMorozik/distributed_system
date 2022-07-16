defmodule Core.ApplicationLayer.GettingProviderInvoiceService do
  @moduledoc false

  alias Core.DomainLayer.UseCases.GettingProviderInvoiceUseCase

  alias Core.DomainLayer.Ports.GettingProviderInvoicePort

  alias Core.DomainLayer.ValueObjects.Id

  @behaviour GettingProviderInvoiceUseCase

  @callback get(
              binary(), GettingProviderInvoicePort.t()
            ) :: GettingProviderInvoiceUseCase.ok() | GettingProviderInvoiceUseCase.error()
  def get(maybe_id, getting_provider_invoice_port) do
    with {:ok, value_id} <- Id.from_origin(maybe_id),
         {:ok, invoice_entity} <- getting_provider_invoice_port.get(value_id) do
      {:ok, invoice_entity}
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end
end
