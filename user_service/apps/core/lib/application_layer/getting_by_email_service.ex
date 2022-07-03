defmodule Core.ApplicationLayer.GettingByEmailService do
  @moduledoc false

  alias Core.DomainLayer.UseCases.GettingByEmailUseCase

  alias Core.DomainLayer.ValueObjects.Email

  alias Core.DomainLayer.Ports.GettingByEmailPort

  @behaviour GettingByEmailUseCase

  @spec get(binary(), GettingByEmailPort.t()) :: GettingByEmailUseCase.ok() | GettingByEmailUseCase.error()
  def get(email, getting_by_email_port) do
    with {:ok, value_email} <- Email.new(email),
         {:ok, user_entity} <- getting_by_email_port.get_by_email(value_email) do
      {:ok, user_entity}
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end
end
