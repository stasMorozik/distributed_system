defmodule Core.DomainLayer.UseCases.ParsinfUseCase do
  @typedoc false

  alias Core.DomainLayer.ValueObjects.Token

  @type ok :: {:ok, Token.claims()}

  @type error :: Token.error_parsing()

  @callback parse(binary(), binary()) :: ok() | error()
end
