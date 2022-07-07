defmodule Core.DomainLayer.Ports.UpdatingBuyerPort do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ServiceUnavailableError

  @type t :: Module

  @type ok :: {:ok, true}

  @type error :: {
          :error,
          struct()
          | ServiceUnavailableError.t()
        }

  @type updating_dto ::
        %{
          email: any(),
          password: any()
        }

  @callback update(binary(), updating_dto()) :: ok() | error()
end
