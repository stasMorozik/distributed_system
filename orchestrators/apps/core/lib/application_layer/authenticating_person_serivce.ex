defmodule Core.ApplicationLayer.AuthenticatingPersonService do
  @moduledoc false

  alias Core.DomainLayer.UseCases.AuthenticatingPersonUseCase
  alias Core.DomainLayer.Ports.GettingPersonByEmailPort
  alias Core.DomainLayer.Ports.CreatingJwtPort

  @behaviour AuthenticatingPersonUseCase

  @spec authenticate(
          binary(),
          binary(),
          CreatingJwtPort.t(),
          GettingPersonByEmailPort.t()
        ) :: AuthenticatingPersonUseCase.ok() | AuthenticatingPersonUseCase.error()
  def authenticate(email, password, creating_jwt_port, getting_user_by_email_port) do
    with {:ok, person_entity} <- getting_user_by_email_port.get(email, password),
         {:ok, jwt_entity} <- creating_jwt_port.create(email, password, person_entity.id) do
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
