defmodule Core.ApplicationLayer.RefreshingService do
  @moduledoc false

  alias Core.DomainLayer.UseCases.RefreshingUseCase

  alias Core.DomainLayer.JWTEntity

  @behaviour RefreshingUseCase

  @spec refresh(binary(), binary(), binary()) :: RefreshingUseCase.ok() | RefreshingUseCase.error()
  def refresh(token, secret, secret_exchanging) do
    JWTEntity.refresh(token, secret, secret_exchanging)
  end
end
