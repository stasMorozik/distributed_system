defmodule Core.DomainLayer.Ports.CreatingCustomerInvoicePort do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ServiceUnavailableError

  @type t :: Module

  @type ok :: {:ok, struct()}

  @type error :: {
          :error,
          struct()
          | ServiceUnavailableError.t()
        }

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

  @callback create_invoice(creating_dto()) :: ok() | error()
end
