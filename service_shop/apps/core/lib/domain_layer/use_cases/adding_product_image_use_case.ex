defmodule Core.DomainLayer.UseCases.AddingProductImageUseCase do
  @moduledoc false

  alias Core.DomainLayer.Ports.AddingProductImagePort

  alias Core.DomainLayer.Ports.GettingProductPort

  alias Core.DomainLayer.ValueObjects.Id

  alias Core.DomainLayer.ImageEntity

  alias Core.DomainLayer.ProductAggregate

  @type t :: Module

  @type ok :: {:ok, true}

  @type error ::
          Id.error()
          | ImageEntity.error_creating()
          | AddingProductImagePort.error()
          | GettingProductPort.error()
          | ProductAggregate.error_adding_image()

  @callback add(
              binary(),
              list(binary()),
              GettingProductPort.t(),
              AddingProductImagePort.t()
            ) :: ok() | error()
end
