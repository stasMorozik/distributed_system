defmodule Core.ApplicationLayer.UpdatingBuyerService do
  @moduledoc false

  alias Core.DomainLayer.UseCases.UpdatingBuyerUseCase

  alias Core.DomainLayer.Ports.UpdatingBuyerPort
  alias Core.DomainLayer.Ports.ParsingJwtPort

  @behaviour UpdatingBuyerUseCase

  @spec update(
          binary(),
          UpdatingBuyerUseCase.updating_dto(),
          ParsingJwtPort.t(),
          UpdatingBuyerPort.t()
        ) :: UpdatingBuyerUseCase.ok() | UpdatingBuyerUseCase.error()
  def update(token, dto, parsing_jwt_port, updating_buyer_port) do
    with {:ok, claims} <- parsing_jwt_port.parse(token),
         {:ok, _} <-
           updating_buyer_port.update(claims.id, %{
             password: dto[:password]
           }) do
      {:ok, true}
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end
end
