defmodule Controller do
  @moduledoc false

  alias PostgresAdapters

  alias Core.ApplicationLayer.CreatingService

  alias Core.ApplicationLayer.ValidatingService

  alias Core.DomainLayer.UseCases.CreatingUseCase

  alias Core.DomainLayer.UseCases.ValidatingUseCase

  @spec create(binary()) :: CreatingUseCase.ok() | CreatingUseCase.error()
  def create(email) do
    CreatingService.create(email, PostgresAdapters, PostgresAdapters, PostgresAdapters)
  end

  @spec validate(binary(), integer()) :: ValidatingUseCase.ok() | ValidatingUseCase.error()
  def validate(email, code) do
    ValidatingService.validate(email, code, PostgresAdapters, PostgresAdapters)
  end
end
