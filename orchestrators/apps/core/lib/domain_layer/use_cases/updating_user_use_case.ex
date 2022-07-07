defmodule Core.DomainLayer.UseCases.UpdatingUserUseCase do
  @moduledoc false

  alias Core.DomainLayer.Ports.UpdatingUserPort
  alias Core.DomainLayer.Ports.ParsingJwtPort

  @type ok :: {:ok, true}

  @type error :: UpdatingUserPort.error()
                | ParsingJwtPort.error()

  @type updating_dto :: %{
          name: any(),
          surname: any(),
          phone: any(),
          password: any,
          avatar: any()
        }

  @callback update(
        binary(),
        updating_dto(),
        ParsingJwtPort.t(),
        UpdatingUserPort.t()
      ) :: ok() | error()
end
