defmodule Core.ApplicationLayer.ValidatingService do
  @moduledoc false

  alias Core.DomainLayer.UseCases.ValidatingUseCase

  alias Core.DomainLayer.Ports.GettingPort

  alias Core.DomainLayer.Ports.DeletingPort

  alias Core.DomainLayer.ConfirmingCodeEntity

  alias Core.DomainLayer.ValueObjects.Email

  @behaviour ValidatingUseCase

  @spec validate(binary(), integer(), GettingPort.t(), DeletingPort.t()) ::
          ValidatingUseCase.ok() | ValidatingUseCase.error()
  def validate(maybe_email, code, getting_port, deleting_port) do
    with {:ok, value_email} <- Email.new(maybe_email),
         {:ok, code_entity} <- getting_port.get(value_email),
         {:ok, true} <- ConfirmingCodeEntity.validate_code(code, code_entity),
         {:ok, true} <- deleting_port.delete(value_email) do
      {:ok, true}
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end
end
