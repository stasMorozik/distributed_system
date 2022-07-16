defmodule Core.DomainLayer.Ports.CreatingCustomerInvoicePort do
  @moduledoc false

  alias Core.DomainLayer.CustomerInvoiceAggregate
  alias Core.DomainLayer.Dtos.ImpossibleCreateError

  @type t :: Module

  @type ok :: {:ok, true}

  @type error :: {:error, ImpossibleCreateError.t()}

  @callback create(CustomerInvoiceAggregate.t()) :: ok() | error()
end
