defmodule Core.DomainLayer.UseCases.RefreshingJwtUseCase do
  @moduledoc """
   This use case is shared between the buyer and the user, so its name is PersonUseCase.
  """

  alias Core.DomainLayer.Ports.RefreshingJwtPort

  @type ok :: {:ok, struct()}

  @type error :: RefreshingJwtPort.error()

  @callback refresh(binary(), RefreshingJwtPort.t()) :: ok() | error()
end
