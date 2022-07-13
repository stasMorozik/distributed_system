defmodule Core.DomainLayer.Ports.GettingProductPort do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ImpossibleGetError

  alias Core.DomainLayer.Dtos.NotFoundError

  alias Core.DomainLayer.ValueObjects.Id

  alias Core.DomainLayer.ProductAggregate

  @type t :: Module

  @type ok :: {:ok, ProductAggregate.t()}

  @type error :: {:error, NotFoundError.t() | ImpossibleGetError.t()}

  @callback get(Id.t()) :: ok() | error()
end
