defmodule Core.DomainLayer.UseCases.RegistrationBuyerUseCase do
  @moduledoc false

  alias Core.DomainLayer.Ports.ValidatingConfirmingCodePort
  alias Core.DomainLayer.Ports.CreatingBuyerPort

  @type ok :: {:ok, true}

  @type error :: ValidatingConfirmingCodePort.error() | CreatingBuyerPort.error()

  @type creating_dto ::
        %{
          email: binary(),
          password: binary(),
          code: integer()
        }

  @callback register(
              creating_dto(),
              ValidatingConfirmingCodePort.t(),
              CreatingBuyerPort.t()
            ) :: ok() | error()
end
