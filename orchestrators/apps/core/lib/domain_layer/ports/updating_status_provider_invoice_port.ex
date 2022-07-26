defmodule Core.DomainLayer.Ports.UpdatingStatusProviderInvoicePort do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ServiceUnavailableError

  @type t :: Module

  @type ok :: {:ok, true}

  @type error :: {
          :error,
          struct()
          | ServiceUnavailableError.t()
        }

  @callback update_status_provider_invoice(binary()) :: ok() | error()
end
