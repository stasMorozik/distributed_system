defmodule Core.DomainLayer.UseCases.AuthenticatingUserService do
  @moduledoc false

  alias Core.DomainLayer.UseCases.AuthenticatingUserUseCase
  alias Core.DomainLayer.Ports.GettingUserByEmailPort
  alias Core.DomainLayer.Ports.CreatingJwtPort

  @behaviour AuthenticatingUserUseCase

  @spec authenticate(
          binary(),
          binary(),
          CreatingJwtPort.t(),
          GettingUserByEmailPort.t()
        ) :: AuthenticatingUserUseCase.ok() | AuthenticatingUserUseCase.error()
  def authenticate(email, password, creating_jwt_port, getting_user_by_email_port) do
    with {:ok, user_entity} <- getting_user_by_email_port.get(email, password),
         {:ok, jwt_entity} <- creating_jwt_port.create(user_entity.email.value, user_entity.password.value) do
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
