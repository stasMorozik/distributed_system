defmodule Core.DomainLayer.UseCases.GettingProductUseCase do
  @moduledoc false

  alias Core.DomainLayer.Ports.GettingProductPort

  @type t :: Module

  @type ok :: {:ok, struct()}

  @type error :: GettingProductPort.error

  @callback get(binary(), GettingProductPort.t()) :: ok() | error()
end
