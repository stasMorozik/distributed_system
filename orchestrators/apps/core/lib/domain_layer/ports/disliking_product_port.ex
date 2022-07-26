defmodule Core.DomainLayer.Ports.DislikingProductPort do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ServiceUnavailableError

  @type t :: Module

  @type ok :: {:ok, true}

  @type error :: {
          :error,
          struct()
          | ServiceUnavailableError.t()
        }

  @type disliking_dto :: %{
          email: binary(),
          id: binary()
        }

  @callback dislike_product(binary(), disliking_dto()) :: ok() | error()
end
