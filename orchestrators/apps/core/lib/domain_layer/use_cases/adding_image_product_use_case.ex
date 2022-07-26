defmodule Core.DomainLayer.UseCases.AddingImageProductUseCase do
  @moduledoc false

  alias Core.DomainLayer.Ports.AddingImageProductPort
  alias Core.DomainLayer.Ports.ParsingJwtPort

  @type t :: Module

  @type ok :: {:ok, true}

  @type error ::
          AddingImageProductPort.error
          | ParsingJwtPort.error()

  @callback add(
              binary(),
              binary(),
              list(binary()),
              ParsingJwtPort.t(),
              AddingImageProductPort.t()
            ) :: ok() | error()
end
