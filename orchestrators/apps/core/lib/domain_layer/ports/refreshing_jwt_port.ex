defmodule Core.DomainLayer.Ports.RefreshingJwtPort do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ServiceUnavailableError

  @type t :: Module

  @type ok :: {:ok, struct()}

  @type error :: {
          :error,
          struct()
          | ServiceUnavailableError.t()
        }

  @callback refresh(binary()) :: ok() | error()
end
