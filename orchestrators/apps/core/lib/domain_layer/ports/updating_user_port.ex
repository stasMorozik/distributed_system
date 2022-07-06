defmodule Core.DomainLayer.Ports.UpdatingUserPort do
  @moduledoc false

  alias Core.DomainLayer.Ports.UpdatingUserPort

  @type t :: Module

  @type ok :: {:ok, true}

  @type error :: {
          :error,
          struct()
          | ServiceUnavailableError.t()
        }

  @type updating_dto ::
        %{
          name: any(),
          surname: any(),
          email: any(),
          phone: any(),
          password: any(),
          avatar: any()
        }

  @callback update(binary(), updating_dto()) :: ok() | error()
end
