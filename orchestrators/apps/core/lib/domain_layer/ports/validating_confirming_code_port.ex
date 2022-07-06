defmodule Core.DomainLayer.Ports.ValidatingConfirmingCodePort do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ServiceUnavailableError

  @type t :: Module

  @type ok :: {:ok, true}

  @type error :: {
          :error,
          struct()
          | ServiceUnavailableError.t()
        }


  @callback validate(binary(), integer()) :: ok() | error()
end
