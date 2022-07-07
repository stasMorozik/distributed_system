defmodule Core.ApplicationLayer.GettingByEmailService do
  @moduledoc false

  alias Core.DomainLayer.UseCases.GettingByEmailUseCase

  alias Core.DomainLayer.ValueObjects.Email

  alias Core.DomainLayer.Ports.GettingByEmailPort

  alias Core.DomainLayer.BuyerEntity

  @behaviour GettingByEmailUseCase

  @spec get(binary(), binary(), GettingByEmailPort.t()) :: GettingByEmailUseCase.ok() | GettingByEmailUseCase.error()
  def get(email, password, getting_by_email_port) do
    with {:ok, value_email} <- Email.new(email),
         {:ok, user_entity} <- getting_by_email_port.get_by_email(value_email),
         {:ok, true} <- BuyerEntity.validate_password(user_entity, password) do
      {:ok, user_entity}
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end
end
