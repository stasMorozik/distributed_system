defmodule Core.DomainLayer.Ports.GettingLIstCustomerInvoicePort do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ServiceUnavailableError

  @type t :: Module

  @type ok :: {:ok, struct()}

  @type error :: {
          :error,
          struct()
          | ServiceUnavailableError.t()
        }

  @type dto_pagination :: %{
          limit: integer(),
          offset: integer()
        }

  @type dto_sorting :: %{
          type: binary(),
          value: binary()
        }

  @type dto_filtration :: %{
          provider: binary() | nil,
          customer: binary() | nil
        }

  @type dto_spliting :: %{
          value: binary()
        }

  @callback get_list_customer_invoice(
              dto_pagination(),
              dto_sorting()    | nil,
              dto_filtration() | nil,
              dto_spliting()   | nil
            ) :: ok() | error()
end
