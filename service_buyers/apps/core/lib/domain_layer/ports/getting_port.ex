defmodule Core.DomainLayer.Ports.GettingPort do
  @moduledoc false

  alias Core.DomainLayer.Dtos.NotFoundError

  alias Core.DomainLayer.ValueObjects.Id

  alias Core.DomainLayer.BuyerEntity

  @type t :: Module

  @type ok :: {:ok, BuyerEntity.t()}

  @type error :: {:error, NotFoundError.t()}

  @callback get(Id.t()) :: ok() | error()
end
