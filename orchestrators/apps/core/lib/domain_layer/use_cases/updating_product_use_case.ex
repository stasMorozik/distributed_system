defmodule Core.DomainLayer.UseCases.UpdatingProductUseCae do
  @moduledoc false

  alias Core.DomainLayer.Ports.UpdatingProductPort
  alias Core.DomainLayer.Ports.ParsingJwtPort

  @type t :: Module

  @type ok :: {:ok, true}

  @type error ::
          UpdatingProductPort.error
          | ParsingJwtPort.error()

  @type updating_dto :: %{
            name: binary()        | nil,
            description: binary() | nil,
            price: integer()      | nil,
            logo: binary()        | nil,
            amount: integer()     | nil
          }

  @callback update(
              binary(),
              binary(),
              updating_dto(),
              ParsingJwtPort.t(),
              UpdatingProductPort.t()
            ) :: ok() | error()
end
