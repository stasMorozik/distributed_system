defmodule Controller do
  @moduledoc false

  alias Core.ApplicationLayer.CreatingService
  alias Core.ApplicationLayer.ParsingService
  alias Core.ApplicationLayer.ExchangingService

  alias Core.DomainLayer.UseCases.ExchangingUseCase
  alias Core.DomainLayer.UseCases.ParsinfUseCase
  alias Core.DomainLayer.UseCases.CreatingUseCase

  @spec create(binary(), binary(), binary(), binary()) :: CreatingUseCase.error() | CreatingUseCase.ok()
  def create(email, password, secret, secret_exchanging) do
    CreatingService.create(email, password, secret, secret_exchanging)
  end

  @spec exchange(binary(), binary(), binary()) :: ExchangingUseCase.ok() | ExchangingUseCase.error()
  def exchange(token, secret, secret_exchanging) do
    ExchangingService.exchange(token, secret, secret_exchanging)
  end

  @spec parse(binary(), binary()) :: ParsinfUseCase.ok() | ParsinfUseCase.error()
  def parse(token, secret) do
    ParsingService.parse(token, secret)
  end
end
