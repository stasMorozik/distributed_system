defmodule Core.ApplicationLayer.UpdatingService do
  @moduledoc false

  alias Core.DomainLayer.UseCases.UpdatingUseCase

  alias Core.DomainLayer.Ports.UpdatingPort

  alias Core.DomainLayer.Ports.GettingPort

  alias Core.DomainLayer.ValueObjects.Id

  alias Core.DomainLayer.UserEntity

  @spec update(binary(), UserEntity.updating_dto(), GettingPort.t(), UpdatingPort.t()) :: UpdatingUseCase.ok() | UpdatingUseCase.error()
  def update(maybe_id, updating_dto, getting_port, updating_port) do
    with {:ok, value_id} <- Id.form_origin(maybe_id),
         {:ok, user_entity} <- getting_port.get(value_id),
         {:ok, user_entity} <- UserEntity.update(user_entity, updating_dto),
         {:ok, true} <- updating_port.update(user_entity) do
      {:ok, true}
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end
end
