defmodule Core.DomainLayer.UseCases.GettingProviderInvoiceUseCase do
  @moduledoc false

  alias Core.DomainLayer.Ports.GettingProviderInvoicePort

  alias Core.DomainLayer.ProviderInvoiceAggregate

  alias Core.DomainLayer.ValueObjects.Id

  @type t :: Module

  @type ok :: {:ok, ProviderInvoiceAggregate.t()}

  @type error ::
          Id.error()
          | GettingProviderInvoicePort.error()

  @callback get(binary(), GettingProviderInvoicePort.t()) :: ok() | error()
end
