defmodule Core.DomainLayer.Ports.AddingImageProductPort do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ServiceUnavailableError

  @type t :: Module

  @type ok :: {:ok, true}

  @type error :: {
          :error,
          struct()
          | ServiceUnavailableError.t()
        }

  @callback add_image(binary(), list(binary())) :: ok() | error()
end
