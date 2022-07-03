defmodule Core.ApplicationLayer.CreatingService do
  @moduledoc false

  alias Core.DomainLayer.UseCases.CreatingUseCase

  alias Core.DomainLayer.UserEntity

  @behaviour CreatingUseCase

  @spec create(UserEntity.creating_dto(), CreatingPort.t()) :: CreatingUseCase.ok() | CreatingUseCase.error()
  def create(creating_dto, creating_port) do
    with {:ok, user_entity} <- UserEntity.new(creating_dto),
         {:ok, true} <- creating_port.create(user_entity) do
      {:ok, true}
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end
end
