defmodule Core.DomainLayer.UseCases.CreatingProductUseCase do
  @moduledoc false

  alias Core.DomainLayer.Ports.CreatingProductPort

  alias Core.DomainLayer.ProductAggregate

  @type t :: Module

  @type ok :: {:ok, true}

  @type error :: CreatingProductPort.error() | ProductAggregate.error_creating()

  @callback create(ProductAggregate.creating_dto(), CreatingProductPort.t()) :: ok() | error()
end
