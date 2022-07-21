defmodule Core.DomainLayer.Ports.UpdatingProviderInvoicePort do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ImpossibleUpdateError

  alias Core.DomainLayer.ProviderInvoiceAggregate

  @type t :: Module

  @type ok :: {:ok, true}

  @type error :: {:error, ImpossibleUpdateError.t()}

  @callback update(ProviderInvoiceAggregate.t()) :: ok() | error()
end
