defmodule Core.DomainLayer.Ports.GettingProductPort do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ServiceUnavailableError

  @type t :: Module

  @type ok :: {:ok, struct()}

  @type error :: {
          :error,
          struct()
          | ServiceUnavailableError.t()
        }

  @callback get_product(binary()) :: ok() | error()
end
