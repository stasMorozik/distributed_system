defmodule Core.DomainLayer.UseCases.GettingListProductUseCase do
  @moduledoc false

  alias Core.DomainLayer.Ports.GettingListProductPort

  @type t :: Module

  @type ok :: {:ok, struct()}

  @type error :: GettingListProductPort.error

  @callback get(
              GettingListProductPort.dto_pagination(),
              GettingListProductPort.dto_sorting()    | nil,
              GettingListProductPort.dto_filtration() | nil,
              GettingListProductPort.dto_spliting()   | nil,
              GettingListProductPort.t()
            ) :: ok() | error()
end
