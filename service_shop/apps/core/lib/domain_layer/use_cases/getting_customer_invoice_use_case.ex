defmodule Core.DomainLayer.UseCases.GettingCustomerInvoiceUseCase do
  @moduledoc false

  alias Core.DomainLayer.Ports.GettingCustomerInvoicePort

  alias Core.DomainLayer.CustomerInvoiceAggregate

  alias Core.DomainLayer.ValueObjects.Id

  @type t :: Module

  @type ok :: {:ok, CustomerInvoiceAggregate.t()}

  @type error ::
          Id.error()
          | GettingCustomerInvoicePort.error()

  @callback get(binary(), GettingCustomerInvoicePort.t()) :: ok() | error()
end
