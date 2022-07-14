defmodule Core.DomainLayer.UseCases.DislikingProductUseCase do
  @moduledoc false

  alias Core.DomainLayer.ProductAggregate

  alias Core.DomainLayer.ValueObjects.Id

  alias Core.DomainLayer.Ports.GettingProductPort

  alias Core.DomainLayer.Ports.AddingProductDislikePort

  alias Core.DomainLayer.Ports.DeletingProductDislikePort

  alias Core.DomainLayer.OwnerEntity

  @type t :: Module

  @type ok :: {:ok, true}

  @type error ::
          Id.error()
          | OwnerEntity.error_creating()
          | ProductAggregate.error_voiting()
          | GettingProductPort.error()
          | AddingProductDislikePort.error()
          | DeletingProductDislikePort.error()

  @type owner_dto :: %{
          email: binary(),
          id: binary()
        }

  @callback dislike(
              binary(),
              owner_dto(),
              GettingProductPort.t(),
              AddingProductDislikePort.t(),
              DeletingProductDislikePort.t()
            ) :: ok() | error()
end
