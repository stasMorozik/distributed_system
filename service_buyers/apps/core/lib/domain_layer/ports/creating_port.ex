defmodule Core.DomainLayer.Ports.CreatingPort do
  @moduledoc false

  alias Core.DomainLayer.BuyerEntity
  alias Core.DomainLayer.Errors.InfrastructureError

  @type t :: Module

  @type ok :: {:ok, true}

  @type error :: {:error, InfrastructureError.t()}

  @callback create(BuyerEntity.t()) :: ok() | error()
end
