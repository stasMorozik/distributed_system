defmodule Core.DomainLayer.Ports.CreatingProductPort do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ImpossibleCreateError
  alias Core.DomainLayer.ProductAggregate

  @type t :: Module

  @type ok :: {:ok, true}

  @type error :: {:error, ImpossibleCreateError.t()}

  @callback create(ProductAggregate.t()) :: ok() | error()
end
