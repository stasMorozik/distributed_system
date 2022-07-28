defmodule Core.DomainLayer.UseCases.GettingListCustomerInvoiceUseCase do
  @moduledoc false

  alias Core.DomainLayer.Ports.GettingLIstCustomerInvoicePort
  alias Core.DomainLayer.Ports.ParsingJwtPort

  @type t :: Module

  @type ok :: {:ok, struct()}

  @type error ::
        ParsingJwtPort.error()
        | GettingLIstCustomerInvoicePort.error

  @callback get(
              binary(),
              GettingLIstCustomerInvoicePort.dto_pagination(),
              GettingLIstCustomerInvoicePort.dto_sorting()    | nil,
              GettingLIstCustomerInvoicePort.dto_filtration() | nil,
              GettingLIstCustomerInvoicePort.dto_spliting()   | nil,
              ParsingJwtPort.t(),
              GettingLIstCustomerInvoicePort.t()
            ) :: ok() | error()
end
