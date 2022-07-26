defmodule Core.DomainLayer.UseCases.DislikingProductUseCase do
  @moduledoc false

  alias Core.DomainLayer.Ports.DislikingProductPort
  alias Core.DomainLayer.Ports.ParsingJwtPort

  @type t :: Module

  @type ok :: {:ok, true}

  @type error ::
          DislikingProductPort.error
          | ParsingJwtPort.error()

  @callback dislike(
              binary(),
              binary(),
              ParsingJwtPort.t(),
              DislikingProductPort.t()
            ) :: ok() | error()
end
