defmodule Core.DomainLayer.Ports.GettingPort do
  @moduledoc false

  alias Core.DomainLayer.ConfirmingCodeEntity
  alias Core.DomainLayer.ValueObjects.Email
  alias Core.DomainLayer.Errors.InfrastructureError

  @type t :: Module

  @type ok :: {
          :ok,
          ConfirmingCodeEntity.t()
        }

  @type error :: {
          :error,
          InfrastructureError.t()
        }

  @callback get(Email.t()) :: ok() | error()
end
