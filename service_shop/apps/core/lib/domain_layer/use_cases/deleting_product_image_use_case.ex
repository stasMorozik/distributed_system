defmodule Core.DomainLayer.UseCases.DeletingProductImageUseCase do
  @moduledoc false

  alias Core.DomainLayer.Ports.DeletingProductImagePort

  alias Core.DomainLayer.Ports.GettingProductPort

  alias Core.DomainLayer.ProductAggregate

  alias Core.DomainLayer.ValueObjects.Id

  @type t :: Module

  @type ok :: {:ok, true}

  @type error ::
          Id.error()
          | DeletingProductImagePort.error()
          | GettingProductPort.error()
          | ProductAggregate.error_deleting_image()

  @callback delete(binary(), binary(), GettingProductPort.t(), DeletingProductImagePort.t()) :: ok() | error()
end
