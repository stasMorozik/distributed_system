defmodule Core.ApplicationLayer.RegistrationUserService do
  @moduledoc false

  alias Core.DomainLayer.UseCases.RegistrationUserUseCase

  alias Core.DomainLayer.Ports.ValidatingConfirmingCodePort
  alias Core.DomainLayer.Ports.CreatingUserPort

  @behaviour RegistrationUserUseCase

  @spec register(
          RegistrationUserUseCase.creating_dto(),
          ValidatingConfirmingCodePort.t(),
          CreatingUserPort.t()
        ) :: RegistrationUserUseCase.ok() | RegistrationUserUseCase.error()
  def register(dto, validating_confirming_code_port, creating_user_port) do
    with {:ok, _} <- validating_confirming_code_port.validate(dto[:email], dto[:code]),
         {:ok, _} <-
           creating_user_port.create(%{
             name: dto[:name],
             surname: dto[:surname],
             email: dto[:email],
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
