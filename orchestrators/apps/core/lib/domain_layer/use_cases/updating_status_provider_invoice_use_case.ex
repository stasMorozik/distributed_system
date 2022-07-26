defmodule Core.DomainLayer.UseCases.UpdatingStatusProviderInvoiceUseCase do
  @moduledoc false

  alias Core.DomainLayer.Ports.UpdatingStatusProviderInvoicePort
  alias Core.DomainLayer.Ports.ParsingJwtPort

  @type t :: Module

  @type ok :: {:ok, true}

  @type error ::
          UpdatingProductPort.error
          | ParsingJwtPort.error()

  @callback update(
              binary(),
              binary(),
              ParsingJwtPort.t(),
              UpdatingStatusProviderInvoicePort.t()
            ) :: ok() | error()
end
