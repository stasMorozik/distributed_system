defmodule Core.ApplicationLayer.UpdatingPersonEmailService do
  @moduledoc false

  alias Core.DomainLayer.UseCases.UpdatingPersonEmailUseCase

  alias Core.DomainLayer.Ports.ValidatingConfirmingCodePort
  alias Core.DomainLayer.Ports.UpdatingUserPort
  alias Core.DomainLayer.Ports.ParsingJwtPort

  @behaviour UpdatingPersonEmailUseCase

  @spec update(
          binary(),
          UpdatingPersonEmailUseCase.updating_dto(),
          ParsingJwtPort.t(),
          ValidatingConfirmingCodePort.t(),
          UpdatingUserPort.t()
        ) :: UpdatingPersonEmailUseCase.ok() | UpdatingPersonEmailUseCase.error()
  def update(token, dto, parsing_jwt_port, validating_confirming_code_port, updating_user_port) do
    with {:ok, claims} <- parsing_jwt_port.parse(token),
         {:ok, _} <- validating_confirming_code_port.validate(dto[:email], dto[:code]),
         {:ok, _} <-
           updating_user_port.update(claims.id, %{
             name: nil,
             surname: nil,
             email: dto[:email],
             phone: nil,
             password: nil,
             avatar: nil
           }) do
      {:ok, true}
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end
end
