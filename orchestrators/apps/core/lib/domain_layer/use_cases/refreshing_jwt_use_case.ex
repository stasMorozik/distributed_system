defmodule Core.DomainLayer.UseCases.RefreshingJwtUseCase do
  @moduledoc false

  alias Core.DomainLayer.Ports.RefreshingJwtPort

  @type ok :: {:ok, struct()}

  @type error :: RefreshingJwtPort.error()

  @callback refresh(binary(), RefreshingJwtPort.t()) :: ok() | error()
end
