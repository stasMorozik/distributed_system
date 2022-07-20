defmodule Core.DomainLayer.UseCases.CreatingCustomerInvoiceUseCase do
  @moduledoc false

  alias Core.DomainLayer.Ports.CreatingCustomerInvoicePort
  alias Core.DomainLayer.CustomerInvoiceAggregate
  alias Core.DomainLayer.Ports.GettingProductPort
  alias Core.DomainLayer.ValueObjects.Id

  @type t :: Module

  @type ok :: {:ok, true}

  @type error ::
    Id.error()
    | CreatingCustomerInvoicePort.error()
    | CustomerInvoiceAggregate.error_creating()

  @type product_dto :: %{
          product_id: binary(),
          amount: integer()
        }

  @type creating_dto :: %{
    customer: %{
      email: binary(),
      id: binary()
    },
    products: list(product_dto())
  }

  @callback create(
          creating_dto,
          GettingProductPort.t(),
          CreatingCustomerInvoicePort.t()
        ) :: ok() | error()
end
