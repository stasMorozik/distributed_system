defmodule Core.DomainLayer.UseCases.AuthenticatingUserUseCase do
  @moduledoc false

  alias Core.DomainLayer.Ports.GettingUserByEmailPort
  alias Core.DomainLayer.Ports.CreatingJwtPort

  @type ok :: {:ok, %{token: binary(), exchanging_token: binary()}}

  @type error :: CreatingJwtPort.error() | GettingUserByEmailPort.error()

  @callback authenticate(binary(), binary(), CreatingJwtPort.t(), GettingUserByEmailPort.t()) :: ok() | error()
end
