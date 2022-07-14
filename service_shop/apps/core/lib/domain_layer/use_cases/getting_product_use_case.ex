defmodule Core.DomainLayer.UseCases.GettingProductUseCase do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Id

  alias Core.DomainLayer.Ports.GettingProductPort

  alias Core.DomainLayer.ProductAggregate

  @type t :: Module

  @type ok :: {:ok, ProductAggregate.t()}

  @type error ::
          Id.error()
          | GettingProductPort.error()

  @callback get(binary(), GettingProductPort.t()) :: ok() | error()
end
