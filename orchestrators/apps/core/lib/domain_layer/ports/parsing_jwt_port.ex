defmodule Core.DomainLayer.Ports.ParsingJwtPort do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ServiceUnavailableError

  @type t :: Module

  @type ok :: {:ok, map()}

  @type error :: {
          :error,
          struct()
          | ServiceUnavailableError.t()
        }

  @callback parse(binary()) :: ok() | error()
end
