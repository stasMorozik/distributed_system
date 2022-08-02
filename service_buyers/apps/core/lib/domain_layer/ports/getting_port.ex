defmodule Core.DomainLayer.Ports.GettingPort do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Id
  alias Core.DomainLayer.BuyerEntity
  alias Core.DomainLayer.Errors.InfrastructureError

  @type t :: Module

  @type ok :: {:ok, BuyerEntity.t()}

  @type error :: {:error, InfrastructureError.t()}

  @callback get(Id.t()) :: ok() | error()
end
