defmodule Core.DomainLayer.UseCases.LikingProductUseCase do
  @moduledoc false

  alias Core.DomainLayer.ProductAggregate

  alias Core.DomainLayer.ValueObjects.Id

  alias Core.DomainLayer.Ports.GettingProductPort

  alias Core.DomainLayer.Ports.AddingProductLikePort

  alias Core.DomainLayer.Ports.DeletingProductLikePort

  alias Core.DomainLayer.OwnerEntity

  @type t :: Module

  @type ok :: {:ok, true}

  @type error ::
          Id.error()
          | OwnerEntity.error_creating()
          | ProductAggregate.error_voiting()
          | GettingProductPort.error()
          | AddingProductLikePort.error()
          | DeletingProductLikePort.error()

  @type owner_dto :: %{
          email: binary(),
          id: binary()
        }

  @callback like(
              binary(),
              owner_dto(),
              GettingProductPort.t(),
              AddingProductLikePort.t(),
              DeletingProductLikePort.t()
            ) :: ok() | error()
end
