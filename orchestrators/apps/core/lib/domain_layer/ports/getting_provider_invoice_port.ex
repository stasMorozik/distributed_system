defmodule Core.DomainLayer.Ports.GettingProviderInvoicePort do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ServiceUnavailableError

  @type t :: Module

  @type ok :: {:ok, struct()}

  @type error :: {
          :error,
          struct()
          | ServiceUnavailableError.t()
        }

  @callback get_provider_invoice(binary()) :: ok() | error()
end
