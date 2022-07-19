defmodule Core.DomainLayer.Ports.AddingProductDislikePort do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ImpossibleCreateError

  alias Core.DomainLayer.OwnerEntity

  alias Core.DomainLayer.ValueObjects.Id

  @type t :: Module

  @type ok :: {:ok, true}

  @type error :: {:error, ImpossibleCreateError.t()}

  @callback add(Id.t(), OwnerEntity.t()) :: ok() | error()
end
