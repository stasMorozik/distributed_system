defmodule Core.DomainLayer.UseCases.LikingProductUseCase do
  @moduledoc false

  alias Core.DomainLayer.Ports.LikingProductPort
  alias Core.DomainLayer.Ports.ParsingJwtPort

  @type t :: Module

  @type ok :: {:ok, true}

  @type error ::
          LikingProductPort.error
          | ParsingJwtPort.error()

  @callback like(
              binary(),
              binary(),
              ParsingJwtPort.t(),
              LikingProductPort.t()
            ) :: ok() | error()
end
