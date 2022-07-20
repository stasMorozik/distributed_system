defmodule CreatingCustomerInvoiceAdapter do
  @moduledoc false

  alias Ecto.Multi
  alias Shop.Repo

  alias Core.DomainLayer.Ports.CreatingCustomerInvoicePort

  alias Core.DomainLayer.CustomerInvoiceAggregate
  alias Core.DomainLayer.Dtos.ImpossibleCreateError

  @spec create(CustomerInvoiceAggregate.t()) :: CreatingCustomerInvoicePort.ok() | CreatingCustomerInvoicePort.error()
  def create(%CustomerInvoiceAggregate{} = entity) do

  end
end
