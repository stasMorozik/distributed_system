defmodule Core.DomainLayer.UseCases.CreatingProductUseCase do
  @moduledoc false

  alias Core.DomainLayer.Ports.CreatingProductPort
  alias Core.DomainLayer.Ports.ParsingJwtPort

  @type t :: Module

  @type ok :: {:ok, true}

  @type error ::
          CreatingProductPort.error
          | ParsingJwtPort.error()

  @type creating_dto ::%{
          name: binary(),
          amount: integer(),
          description: binary(),
          price: integer(),
          logo: binary(),
          images: list(binary()),
        }

  @callback create(
              binary(),
              creating_dto(),
              ParsingJwtPort.t(),
              CreatingProductPort.t()
            ) :: ok() | error()
end
