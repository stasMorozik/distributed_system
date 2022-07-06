defmodule Core.ApplicationLayer.UpdatingUserService do
  @moduledoc false

  alias Core.DomainLayer.UseCases.UpdatingUserUseCase

  alias Core.DomainLayer.Ports.UpdatingUserPort
  alias Core.DomainLayer.Ports.ParsingJwtPort

  @behaviour UpdatingUserUseCase

  @callback update(
              binary(),
              UpdatingUserUseCase.updating_dto(),
              ParsingJwtPort.t(),
              UpdatingUserPort.t()
            ) :: UpdatingUserUseCase.ok() | UpdatingUserUseCase.error()
  def update(token, dto, parsing_jwt_port, updating_user_port) do
    with {:ok, claims} <- parsing_jwt_port.parse(token),
         {:ok, _} <-
           updating_user_port.update(claims.id, %{
             name: dto[:name],
             surname: dto[:surname],
             email: nil,
             phone: dto[:phone],
             password: dto[:password],
             avatar: dto[:avatar]
           }) do
      {:ok, true}
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end
end
