defmodule Core.DomainLayer.UseCases.CreatingUseCase do
  @typedoc false

  alias Core.DomainLayer.JWTEntity

  alias Core.DomainLayer.ValueObjects.Token

  @type ok :: {:ok, JWTEntity.t()}

  @type error :: Token.error()

  @callback create(binary(), binary(), binary(), binary()) :: ok() | error()
end
