defmodule Core.ApplicationLayer.UpdatingProductService do
  @moduledoc false

  alias Core.DomainLayer.UseCases.UpdatingProductUseCae
  alias Core.DomainLayer.Ports.UpdatingProductPort
  alias Core.DomainLayer.Ports.ParsingJwtPort

  @behaviour UpdatingProductUseCae

  @spec update(
          binary(),
          binary(),
          UpdatingProductUseCae.updating_dto(),
          ParsingJwtPort.t(),
          UpdatingProductPort.t()
        ) :: UpdatingProductUseCae.ok() | UpdatingProductUseCae.error()
  def update(token, id, dto, parsing_jwt_port, updating_product_port) do
    with {:ok, _} <- parsing_jwt_port.parse(token),
         {:ok, _} <- updating_product_port.update_product(id, dto) do
      {:ok, true}
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end
end
