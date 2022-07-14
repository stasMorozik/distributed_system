defmodule Core.DomainLayer.Ports.AddingProductDislikePort do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ImpossibleCreateError

  alias Core.DomainLayer.OwnerEntity

  @type t :: Module

  @type ok :: {:ok, true}

  @type error :: {:error, ImpossibleCreateError.t()}

  @callback add(OwnerEntity.t()) :: ok() | error()
end
