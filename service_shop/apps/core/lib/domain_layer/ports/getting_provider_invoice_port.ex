defmodule Core.DomainLayer.Ports.GettingProviderInvoicePort do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ImpossibleGetError

  alias Core.DomainLayer.Dtos.NotFoundError

  alias Core.DomainLayer.ValueObjects.Id

  alias Core.DomainLayer.ProviderInvoiceAggregate

  @type t :: Module

  @type ok :: {:ok, ProviderInvoiceAggregate.t()}

  @type error :: {:error, NotFoundError.t() | ImpossibleGetError.t()}

  @callback get(Id.t()) :: ok() | error()
end
