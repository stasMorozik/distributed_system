defmodule Core.DomainLayer.UseCases.GettingProviderInvoiceUseCase do
  @moduledoc false

  alias Core.DomainLayer.Ports.GettingProviderInvoicePort
  alias Core.DomainLayer.Ports.ParsingJwtPort

  @type t :: Module

  @type ok :: {:ok, struct()}

  @type error ::
        ParsingJwtPort.error()
        | GettingProviderInvoicePort.error

  @callback get(binary(), binary(), ParsingJwtPort.t(), GettingProviderInvoicePort.t()) :: ok() | error()
end
