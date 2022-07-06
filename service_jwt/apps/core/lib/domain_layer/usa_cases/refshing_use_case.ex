defmodule Core.DomainLayer.UseCases.RefreshingUseCase do
  @typedoc false

  alias Core.DomainLayer.JWTEntity

  alias Core.DomainLayer.ValueObjects.Token

  @type ok :: {:ok, JWTEntity.t()}

  @type error :: Token.error() | Token.error_parsing()

  @callback refresh(binary(), binary(), binary()) :: ok() | error()
end
