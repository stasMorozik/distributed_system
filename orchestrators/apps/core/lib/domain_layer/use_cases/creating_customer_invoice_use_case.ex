defmodule Core.DomainLayer.UseCases.CreatingCustomerInvoiceUseCase do
  @moduledoc false

  alias Core.DomainLayer.Ports.CreatingCustomerInvoicePort
  alias Core.DomainLayer.Ports.ParsingJwtPort
  alias Core.DomainLayer.Ports.NotifyingMailPort

  @type t :: Module

  @type ok :: {:ok, true}

  @type error ::
          CreatingCustomerInvoicePort.error
          | ParsingJwtPort.error()
          | NotifyingMailPort.error()

  @type product_dto :: %{
          product_id: binary(),
          amount: integer()
        }

  @callback create(
            binary(),
            list(product_dto()),
            ParsingJwtPort.t(),
            CreatingCustomerInvoicePort.t(),
            NotifyingMailPort.t()
          ) :: ok() | error()
end
