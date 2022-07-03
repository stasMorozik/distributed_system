defmodule Controller do

  alias Core.ApplicationLayer.CreatingService

  alias Core.ApplicationLayer.GettingByEmailService

  alias Core.ApplicationLayer.UpdatingService

  alias PostgresAdapters

  #here it's possible add logging

  @spec create(UserEntity.creating_dto()) :: CreatingService.ok() | CreatingService.error()
  def create(creating_dto) do
    CreatingService.create(creating_dto, PostgresAdapters)
  end

  @spec get_by_email(binary()) :: GettingByEmailService.ok() | GettingByEmailService.error()
  def get_by_email(maybe_email) do
    GettingByEmailService.get(maybe_email, PostgresAdapters)
  end

  @spec update(binary(), UserEntity.updating_dto()) :: UpdatingService.ok() | UpdatingService.error()
  def update(maybe_id, updating_dto) do
    UpdatingService.update(maybe_id, updating_dto, PostgresAdapters, PostgresAdapters)
  end
end
