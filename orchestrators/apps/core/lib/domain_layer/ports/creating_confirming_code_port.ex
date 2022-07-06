defmodule Core.DomainLayer.Ports.CreatingConfirmingCodePort do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ServiceUnavailableError

  @type t :: Module

  @type ok :: {
          :ok,
          struct()
        }

  @type error :: {
          :error,
          ServiceUnavailableError.t()
          | struct()
        }

  @callback create(binary()) :: ok() | error()
end
