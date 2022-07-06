defmodule Core.DomainLayer.Ports.GettingPersonByEmailPort do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ServiceUnavailableError

  @type t :: Module

  @type ok :: {
          :ok,
          struct()
        }

  @type error :: {
          :errror,
          struct()
          | ServiceUnavailableError.t()
        }

  @callback get(binary(), binary()) :: ok() | error()
end
