defmodule Core.DomainLayer.UseCases.RegistrationUserUseCase do
  @moduledoc false

  alias Core.DomainLayer.Ports.ValidatingConfirmingCodePort
  alias Core.DomainLayer.Ports.CreatingUserPort

  @type ok :: {:ok, true}

  @type error :: ValidatingConfirmingCodePort.error() | CreatingUserPort.error()

  @type creating_dto ::
        %{
          name: binary(),
          surname: binary(),
          email: binary(),
          phone: binary(),
          password: binary(),
          avatar: binary(),
          code: integer()
        }

  @callback register(
              creating_dto(),
              ValidatingConfirmingCodePort.t(),
              CreatingUserPort.t()
            ) :: ok() | error()
end
