defmodule Core.DomainLayer.UseCases.AuthenticatingPersonUseCase do
  @moduledoc """
   This use case is shared between the buyer and the user, so its name is PersonUseCase.
  """

  alias Core.DomainLayer.Ports.GettingPersonByEmailPort
  alias Core.DomainLayer.Ports.CreatingJwtPort

  @type ok :: {:ok, %{token: binary(), exchanging_token: binary()}}

  @type error :: CreatingJwtPort.error() | GettingPersonByEmailPort.error()

  @callback authenticate(binary(), binary(), CreatingJwtPort.t(), GettingPersonByEmailPort.t()) :: ok() | error()
end
