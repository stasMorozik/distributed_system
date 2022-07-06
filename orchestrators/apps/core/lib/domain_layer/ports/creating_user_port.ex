defmodule Core.DomainLayer.Ports.CreatingUserPort do
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
          name: binary(),
          surname: binary(),
          email: binary(),
          phone: binary(),
          password: binary(),
          avatar: binary()
        }

  @callback create(creating_dto()) :: ok() | error()
end
