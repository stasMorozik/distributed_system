defmodule Core.DomainLayer.Ports.DeletingImageProductPort do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ServiceUnavailableError

  @type t :: Module

  @type ok :: {:ok, true}

  @type error :: {
          :error,
          struct()
          | ServiceUnavailableError.t()
        }

  @callback delete_image(binary(), binary()) :: ok() | error()
end
