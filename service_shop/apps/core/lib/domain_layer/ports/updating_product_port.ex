defmodule Core.DomainLayer.Ports.UpdatingProductPort do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ImpossibleUpdateError

  alias Core.DomainLayer.ProductAggregate

  @type t :: Module

  @type ok :: {:ok, true}

  @type error :: {:error, ImpossibleUpdateError.t()}

  @callback create(ProductAggregate.t()) :: ok() | error()
end
