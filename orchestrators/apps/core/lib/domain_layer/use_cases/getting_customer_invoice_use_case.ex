defmodule Core.DomainLayer.UseCases.GettingCustomerInvoiceUseCase do
  @moduledoc false

  alias Core.DomainLayer.Ports.GettingCustomerInvoicePort
  alias Core.DomainLayer.Ports.ParsingJwtPort

  @type t :: Module

  @type ok :: {:ok, struct()}

  @type error ::
        ParsingJwtPort.error()
        | GettingCustomerInvoicePort.error

  @callback get(
              binary(),
              binary(),
              ParsingJwtPort.t(),
              GettingCustomerInvoicePort.t()
            ) :: ok() | error()
end
