defmodule Core.DomainLayer.UseCases.GettingListProviderInvoiceUseCase do
  @moduledoc false

  alias Core.DomainLayer.Ports.GettingListProviderInvoicePort
  alias Core.DomainLayer.Ports.ParsingJwtPort

  @type t :: Module

  @type ok :: {:ok, struct()}

  @type error ::
        ParsingJwtPort.error()
        | GettingListProviderInvoicePort.error

  @callback get(
              binary(),
              GettingListProviderInvoicePort.dto_pagination(),
              GettingListProviderInvoicePort.dto_sorting()    | nil,
              GettingListProviderInvoicePort.dto_filtration() | nil,
              GettingListProviderInvoicePort.dto_spliting()   | nil,
              ParsingJwtPort.t(),
              GettingListProviderInvoicePort.t()
            ) :: ok() | error()
end
