defmodule Core.DomainLayer.UseCases.DeletingImageProductUseCase do
  @moduledoc false

  alias Core.DomainLayer.Ports.DeletingImageProductPort
  alias Core.DomainLayer.Ports.ParsingJwtPort

  @type t :: Module

  @type ok :: {:ok, true}

  @type error ::
          DeletingImageProductPort.error
          | ParsingJwtPort.error()

  @callback delete(
              binary(),
              binary(),
              binary(),
              ParsingJwtPort.t(),
              DeletingImageProductPort.t()
            ) :: ok() | error()
end
