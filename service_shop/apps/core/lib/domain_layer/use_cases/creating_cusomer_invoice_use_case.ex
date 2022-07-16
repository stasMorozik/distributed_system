defmodule Core.DomainLayer.UseCases.CreatingCustomerInvoiceUseCase do
  @moduledoc false

  alias Core.DomainLayer.Ports.CreatingCustomerInvoicePort
  alias Core.DomainLayer.CustomerInvoiceAggregate

  @type t :: Module

  @type ok :: {:ok, true}

  @type error :: CreatingCustomerInvoicePort.error() | CustomerInvoiceAggregate.error_creating()

  @callback create(
          CustomerInvoiceAggregate.creating_dto(),
          CreatingCustomerInvoicePort.t()
        ) :: ok() | error()
end
