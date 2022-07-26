defmodule Core.DomainLayer.Ports.LikingProductPort do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ServiceUnavailableError

  @type t :: Module

  @type ok :: {:ok, true}

  @type error :: {
          :error,
          struct()
          | ServiceUnavailableError.t()
        }

  @type liking_dto :: %{
          email: binary(),
          id: binary()
        }

  @callback like_product(binary(), liking_dto()) :: ok() | error()
end
