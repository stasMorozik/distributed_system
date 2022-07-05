defmodule Core.DomainLayer.UseCases.ExchangingUseCase do
  @typedoc false

  alias Core.DomainLayer.JWTEntity

  alias Core.DomainLayer.ValueObjects.Token

  @type ok :: {:ok, JWTEntity.t()}

  @type error :: Token.error() | Token.error_parsing()

  @callback exchange(binary(), binary(), binary()) :: ok() | error()
end
