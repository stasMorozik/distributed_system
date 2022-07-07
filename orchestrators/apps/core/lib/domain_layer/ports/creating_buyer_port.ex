defmodule Core.DomainLayer.Ports.CreatingBuyerPort do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ServiceUnavailableError

  @type t :: Module

  @type ok :: {:ok, true}

  @type error :: {
          :error,
          struct()
          | ServiceUnavailableError.t()
        }

  @type creating_dto ::
        %{
          email: binary(),
          password: binary(),
        }

  @callback create(creating_dto()) :: ok() | error()
end
