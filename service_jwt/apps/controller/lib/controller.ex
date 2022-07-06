defmodule Controller do
  @moduledoc false

  alias Core.ApplicationLayer.CreatingService
  alias Core.ApplicationLayer.ParsingService
  alias Core.ApplicationLayer.RefreshingService

  alias Core.DomainLayer.UseCases.RefreshingUseCase
  alias Core.DomainLayer.UseCases.ParsinfUseCase
  alias Core.DomainLayer.UseCases.CreatingUseCase

  @spec create(binary(), binary(), binary(), binary()) :: CreatingUseCase.error() | CreatingUseCase.ok()
  def create(email, password, secret, secret_exchanging) do
    CreatingService.create(email, password, secret, secret_exchanging)
  end

  @spec refresh(binary(), binary(), binary()) :: RefreshingUseCase.ok() | RefreshingUseCase.error()
  def refresh(token, secret, secret_exchanging) do
    RefreshingService.refresh(token, secret, secret_exchanging)
  end

  @spec parse(binary(), binary()) :: ParsinfUseCase.ok() | ParsinfUseCase.error()
  def parse(token, secret) do
    ParsingService.parse(token, secret)
  end
end
