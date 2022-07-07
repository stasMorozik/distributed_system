defmodule Core.DomainLayer.UseCases.AuthorizatingPersonUseCase do
  @moduledoc """
   This use case is shared between the buyer and the user, so its name is PersonUseCase.
  """

  alias Core.DomainLayer.Ports.GettingPersonByEmailPort
  alias Core.DomainLayer.Ports.ParsingJwtPort

  @type ok :: {:ok, struct()}

  @type error :: GettingPersonByEmailPort.error() | ParsingJwtPort.error()

  @callback authorizate(binary(), ParsingJwtPort.t(), GettingPersonByEmailPort.t()) :: ok() | error()
end
