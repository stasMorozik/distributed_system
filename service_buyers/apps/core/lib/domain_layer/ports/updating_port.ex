defmodule Core.DomainLayer.Ports.UpdatingPort do
  @moduledoc false

  alias Core.DomainLayer.Errors.InfrastructureError
  alias Core.DomainLayer.BuyerEntity

  @type t :: Module

  @type ok :: {:ok, true}

  @type error :: {:error, InfrastructureError.t()}

  @callback update(BuyerEntity.t()) :: ok() | error()
end
