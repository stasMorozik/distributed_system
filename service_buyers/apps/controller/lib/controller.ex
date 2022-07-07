defmodule Controller do
  @moduledoc false

  alias Core.ApplicationLayer.CreatingService

  alias Core.ApplicationLayer.GettingByEmailService

  alias Core.ApplicationLayer.UpdatingService

  alias PostgresAdapters

  alias Core.DomainLayer.UseCases.CreatingUseCase

  alias Core.DomainLayer.UseCases.GettingByEmailUseCase

  alias Core.DomainLayer.UseCases.UpdatingUseCase

  alias Core.DomainLayer.BuyerEntity

  #here it's possible add logging

  @spec create(BuyerEntity.creating_dto()) :: CreatingUseCase.ok() | CreatingUseCase.error()
  def create(creating_dto) do
    CreatingService.create(creating_dto, PostgresAdapters)
  end

  @spec get_by_email(binary(), binary()) :: GettingByEmailUseCase.ok() | GettingByEmailUseCase.error()
  def get_by_email(maybe_email, maybe_own_password) do
    GettingByEmailService.get(maybe_email, maybe_own_password, PostgresAdapters)
  end

  @spec update(binary(), BuyerEntity.updating_dto()) :: UpdatingUseCase.ok() | UpdatingUseCase.error()
  def update(maybe_id, updating_dto) do
    UpdatingService.update(maybe_id, updating_dto, PostgresAdapters, PostgresAdapters)
  end
end
