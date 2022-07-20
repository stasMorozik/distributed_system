defmodule Core.ApplicationLayer.DislikingProductservice do
  @moduledoc false

  alias Core.DomainLayer.ProductAggregate

  alias Core.DomainLayer.ValueObjects.Id

  alias Core.DomainLayer.Ports.GettingProductPort

  alias Core.DomainLayer.Ports.AddingProductDislikePort

  alias Core.DomainLayer.Ports.DeletingProductDislikePort

  alias Core.DomainLayer.OwnerEntity

  alias Core.DomainLayer.Dtos.AlreadyExistsError

  alias Core.DomainLayer.UseCases.DislikingProductUseCase

  @behaviour DislikingProductUseCase

  @callback dislike(
              binary(),
              DislikingProductUseCase.owner_dto(),
              GettingProductPort.t(),
              AddingProductDislikePort.t(),
              DeletingProductDislikePort.t()
            ) :: DislikingProductUseCase.ok() | DislikingProductUseCase.error()
  def dislike(
        maybe_id,
        dto,
        getting_product_port,
        adding_product_dislike_port,
        deleting_product_dislike_port
      ) do
    with {:ok, value_id} <- Id.from_origin(maybe_id),
         {:ok, owner_entity} <- OwnerEntity.new(%{email: dto[:email], id: dto[:id]}),
         {:ok, product_entity} <- getting_product_port.get(value_id),
         {:ok, _} <- ProductAggregate.dislike(product_entity, owner_entity),
         {:ok, true} <- adding_product_dislike_port.add(value_id, owner_entity) do
      {:ok, true}
    else
      {:error, error_dto} -> {:error, error_dto}
      {:error, %AlreadyExistsError{message: _}} ->

        with {:ok, true} <- deleting_product_dislike_port.delete(%Id{value: dto[:id]}) do
          {:ok, true}
        else
          {:error, error_dto} -> {:error, error_dto}
        end
    end
  end
end
