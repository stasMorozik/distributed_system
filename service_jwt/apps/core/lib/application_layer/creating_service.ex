defmodule Core.ApplicationLayer.CreatingService do
  @moduledoc false

  alias Core.DomainLayer.UseCases.CreatingUseCase

  alias Core.DomainLayer.JWTEntity

  @behaviour CreatingUseCase

  @spec create(binary(), binary(), binary(), binary(), binary()) :: CreatingUseCase.ok() | CreatingUseCase.error()
  def create(email, password, id, secret, secret_exchanging) do
    JWTEntity.new(email, password, id, secret, secret_exchanging)
  end
end
