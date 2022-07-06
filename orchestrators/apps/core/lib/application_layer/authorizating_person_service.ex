defmodule Core.ApplicationLayer.AuthorizationPersonService do
  @moduledoc false

  alias Core.DomainLayer.UseCases.AuthorizatingPersonUseCase

  alias Core.DomainLayer.Ports.GettingPersonByEmailPort
  alias Core.DomainLayer.Ports.ParsingJwtPort

  @behaviour AuthorizatingPersonUseCase

  @spec authorizate(
          binary(),
          ParsingJwtPort.t(),
          GettingPersonByEmailPort.t()
        ) :: AuthorizatingPersonUseCase.ok() | AuthorizatingPersonUseCase.error()
  def authorizate(token, parsing_jwt_port, getting_person_by_email_port) do
    with {:ok, claims} <- parsing_jwt_port.parse(token),
         {:ok, user_entity} <- getting_person_by_email_port.get(claims.email, claims.password) do
      {:ok, user_entity}
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end
end
