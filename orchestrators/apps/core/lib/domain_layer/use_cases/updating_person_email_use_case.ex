defmodule Core.DomainLayer.UseCases.UpdatingPersonEmailUseCase do
  @moduledoc false

  alias Core.DomainLayer.Ports.ValidatingConfirmingCodePort
  alias Core.DomainLayer.Ports.UpdatingUserPort
  alias Core.DomainLayer.Ports.ParsingJwtPort

  @type ok :: {:ok, true}

  @type error :: UpdatingUserPort.error()
                | ValidatingConfirmingCodePort.error()
                | ParsingJwtPort.error()

  @type updating_dto :: %{
    email: binary(),
    code: integer()
  }

  @callback update(
              binary(),
              updating_dto(),
              ParsingJwtPort.t(),
              ValidatingConfirmingCodePort.t(),
              UpdatingUserPort.t()
            ) :: ok() | error()
end
