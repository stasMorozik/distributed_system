defmodule Core.ApplicationLayer.ExchangingService do
  @moduledoc false

  alias Core.DomainLayer.UseCases.ExchangingUseCase

  alias Core.DomainLayer.JWTEntity

  @behaviour ExchangingUseCase

  @spec exchange(binary(), binary(), binary()) :: ExchangingUseCase.ok() | ExchangingUseCase.error()
  def exchange(token, secret, secret_exchanging) do
    JWTEntity.exchange(token, secret, secret_exchanging)
  end
end
