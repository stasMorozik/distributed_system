defmodule Core.DomainLayer.Ports.UpdatingProductPort do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ServiceUnavailableError

  @type t :: Module

  @type ok :: {:ok, true}

  @type error :: {
          :error,
          struct()
          | ServiceUnavailableError.t()
        }

  @type updating_dto :: %{
          name: binary()        | nil,
          description: binary() | nil,
          price: integer()      | nil,
          logo: binary()        | nil,
          amount: integer()     | nil
        }

  @callback update_product(binary(), updating_dto()) :: ok() | error()
end
