defmodule Core.DomainLayer.Ports.CreatingProductPort do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ServiceUnavailableError

  @type t :: Module

  @type ok :: {:ok, true}

  @type error :: {
          :error,
          struct()
          | ServiceUnavailableError.t()
        }

  @type creating_dto ::%{
          name: binary(),
          amount: integer(),
          description: binary(),
          price: integer(),
          logo: binary(),
          images: list(binary()),
          owner: %{
            id: binary(),
            email: binary()
          }
        }

  @callback create_product(creating_dto()) :: ok() | error()
end
