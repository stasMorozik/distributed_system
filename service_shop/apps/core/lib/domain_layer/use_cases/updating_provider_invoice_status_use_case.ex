defmodule Core.DomainLayer.UseCases.UpdatingProviderInvoiceStatusUseCase do
  @moduledoc false

  alias Core.DomainLayer.Ports.UpdatingProviderInvoicePort

  alias Core.DomainLayer.Ports.GettingProviderInvoicePort

  alias Core.DomainLayer.ProviderInvoiceAggregate

  alias Core.DomainLayer.ValueObjects.Id

  @type t :: Module

  @type ok :: {:ok, true}

  @type error ::
          Id.error()
          | UpdatingProviderInvoicePort.error()
          | GettingProviderInvoicePort.error()
          | ProviderInvoiceAggregate.error_updating()

  @callback update(
              binary(),
              GettingProviderInvoicePort.t(),
              UpdatingProviderInvoicePort.t()
            ) :: ok() | error()
end
