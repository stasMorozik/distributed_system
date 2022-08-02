defmodule Core.DomainLayer.Ports.GettingPort do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Id
  alias Core.DomainLayer.UserAggregate
  alias Core.DomainLayer.Errors.InfrastructureError

  @type t :: Module

  @type ok :: {:ok, UserAggregate.t()}

  @type error :: {:error, InfrastructureError.t()}

  @callback get(Id.t()) :: ok() | error()
end
