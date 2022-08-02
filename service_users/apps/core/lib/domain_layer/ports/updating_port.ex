defmodule Core.DomainLayer.Ports.UpdatingPort do
  @moduledoc false

  alias Core.DomainLayer.UserAggregate
  alias Core.DomainLayer.Errors.InfrastructureError

  @type t :: Module

  @type ok :: {:ok, true}

  @type error :: {:error, InfrastructureError.t()}

  @callback update(UserAggregate.t()) :: ok() | error()
end
