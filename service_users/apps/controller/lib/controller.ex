defmodule Controller do

  alias Core.ApplicationLayer.CreatingService

  alias Core.ApplicationLayer.GettingByEmailService

  alias Core.ApplicationLayer.UpdatingService

  alias GettingAdapter
  alias UpdatingAdapter
  alias GetByEmailAdapter
  alias CreatingAdapter

  alias Core.DomainLayer.UseCases.CreatingUseCase

  alias Core.DomainLayer.UseCases.GettingByEmailUseCase

  alias Core.DomainLayer.UseCases.UpdatingUseCase

  alias Core.DomainLayer.UserEntity

  @spec create(UserEntity.creating_dto()) :: CreatingUseCase.ok() | CreatingUseCase.error()
  def create(creating_dto) do
    CreatingService.create(creating_dto, CreatingAdapter)
  end

  @spec get_by_email(binary(), binary()) :: GettingByEmailUseCase.ok() | GettingByEmailUseCase.error()
  def get_by_email(maybe_email, maybe_own_password) do
    GettingByEmailService.get(maybe_email, maybe_own_password, GetByEmailAdapter)
  end

  @spec update(binary(), UserEntity.updating_dto()) :: UpdatingUseCase.ok() | UpdatingUseCase.error()
  def update(maybe_id, updating_dto) do
    UpdatingService.update(maybe_id, updating_dto, GettingAdapter, UpdatingAdapter)
  end
end
