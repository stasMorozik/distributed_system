defmodule Core.ApplicationLayer.LikingProductservice do
  @moduledoc false

  alias Core.DomainLayer.UseCases.LikingProductUseCase

  alias Core.DomainLayer.ProductAggregate

  alias Core.DomainLayer.ValueObjects.Id

  alias Core.DomainLayer.Ports.GettingProductPort

  alias Core.DomainLayer.Ports.AddingProductLikePort

  alias Core.DomainLayer.Ports.DeletingProductLikePort

  alias Core.DomainLayer.Dtos.AlreadyExistsError

  alias Core.DomainLayer.OwnerEntity

  @behaviour LikingProductUseCase

  @spec like(
              binary(),
              LikingProductUseCase.owner_dto(),
              GettingProductPort.t(),
              AddingProductLikePort.t(),
              DeletingProductLikePort.t()
        ) :: LikingProductUseCase.ok() | LikingProductUseCase.error()
  def like(
        maybe_id,
        %{} = dto,
        getting_product_port,
        adding_product_like_port,
        deleting_product_like_port
      ) do
    with {:ok, value_id} <- Id.from_origin(maybe_id),
         {:ok, owner_entity} <- OwnerEntity.new(dto[:email], dto[:id]),
         {:ok, product_entity} <- getting_product_port.get(value_id),
         {:ok, _} <- ProductAggregate.like(product_entity, owner_entity),
         {:ok, true} <- adding_product_like_port.add(owner_entity) do
      {:ok, true}
    else
      {:error, error_dto} -> {:error, error_dto}
      {:error, %AlreadyExistsError{message: _}} ->

        with {:ok, true} <- deleting_product_like_port.delete(%Id{value: dto[:id]}) do
          {:ok, true}
        else
          {:error, error_dto} -> {:error, error_dto}
        end
    end
  end
end
