defmodule Core.ApplicationLayer.UpdatingProductAmountService do
  @moduledoc false

  alias Core.DomainLayer.UseCases.UpdatingProductAmountUseCase

  alias Core.DomainLayer.Ports.UpdatingProductPort

  alias Core.DomainLayer.Ports.GettingProductPort

  alias Core.DomainLayer.ProductAggregate

  alias Core.DomainLayer.ValueObjects.Id

  @behaviour UpdatingProductAmountUseCase

  @spec update(
          binary(),
          UpdatingProductAmountUseCase.updating_dto(),
          GettingProductPort.t(),
          UpdatingProductPort.t()
        ) :: UpdatingProductAmountUseCase.ok() | UpdatingProductAmountUseCase.error()
  def update(maybe_id, %{} = dto, getting_product_port, updating_product_port) do
    with {:ok, value_id} <- Id.from_origin(maybe_id),
         {:ok, product_entity} <- getting_product_port.get(value_id),
         {:ok, product_entity} <-
           ProductAggregate.update(product_entity, %{
             name: nil,
             amount: dto[:amount],
             description: nil,
             price: nil,
             logo: nil
           }),
         {:ok, true} <- updating_product_port.update(product_entity) do
      {:ok, true}
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end
end
