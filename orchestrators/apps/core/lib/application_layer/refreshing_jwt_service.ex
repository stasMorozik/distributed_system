defmodule Core.ApplicationLayer.RefreshingJwtService do
  @moduledoc false

  alias Core.DomainLayer.UseCases.RefreshingJwtUseCase
  alias Core.DomainLayer.Ports.RefreshingJwtPort

  @behaviour RefreshingJwtUseCase

  @spec refresh(binary(), RefreshingJwtPort.t()) :: RefreshingJwtUseCase.ok() | RefreshingJwtUseCase.error()
  def refresh(refresh_token, refreshing_jwt_port) do
    with {:ok, jwt_entity} <- refreshing_jwt_port.refresh(refresh_token) do
      {
        :ok,
        %{
          token: jwt_entity.token.value,
          refresh_token: jwt_entity.refresh_token.value
        }
      }
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end
end
