defmodule Core.DomainLayer.UseCases.UpdatingBuyerUseCase do
  @moduledoc false

  alias Core.DomainLayer.Ports.UpdatingBuyerPort
  alias Core.DomainLayer.Ports.ParsingJwtPort

  @type ok :: {:ok, true}

  @type error :: UpdatingBuyerPort.error()
                | ParsingJwtPort.error()

  @type updating_dto :: %{
          password: any
        }

  @callback update(
        binary(),
        updating_dto(),
        ParsingJwtPort.t(),
        UpdatingBuyerPort.t()
      ) :: ok() | error()
end
