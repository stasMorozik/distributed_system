defmodule Core.DomainLayer.Ports.DeletingPort do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Email
  alias Core.DomainLayer.Errors.InfrastructureError

  @type t :: Module

  @type ok :: {:ok, true}

  @type error :: {
          :error,
          InfrastructureError.t()
        }

  @callback delete(Email.t()) :: ok() | error()
end
