defmodule Core.ApplicationLayer.RegistrationBuyerService do
  @moduledoc false

  alias Core.DomainLayer.UseCases.RegistrationBuyerUseCase

  alias Core.DomainLayer.Ports.ValidatingConfirmingCodePort
  alias Core.DomainLayer.Ports.CreatingBuyerPort

  @behaviour RegistrationBuyerUseCase

  @spec register(
          RegistrationBuyerUseCase.creating_dto(),
          ValidatingConfirmingCodePort.t(),
          CreatingBuyerPort.t()
        ) :: RegistrationBuyerUseCase.ok() | RegistrationBuyerUseCase.error()
  def register(dto, validating_confirming_code_port, creating_buyer_port) do
    with {:ok, _} <- validating_confirming_code_port.validate(dto[:email], dto[:code]),
        {:ok, _} <-
          creating_buyer_port.create(%{
            email: dto[:email],
            password: dto[:password]
          }) do
      {:ok, true}
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end
end
