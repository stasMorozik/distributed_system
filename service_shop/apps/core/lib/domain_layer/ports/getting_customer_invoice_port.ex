defmodule Core.DomainLayer.Ports.GettingCustomerInvoicePort do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ImpossibleGetError

  alias Core.DomainLayer.Dtos.NotFoundError

  alias Core.DomainLayer.ValueObjects.Id

  alias Core.DomainLayer.CustomerInvoiceAggregate

  @type t :: Module

  @type ok :: {:ok, CustomerInvoiceAggregate.t()}

  @type error :: {:error, NotFoundError.t() | ImpossibleGetError.t()}

  @callback get(Id.t()) :: ok() | error()
end
