defmodule Core.ApplicationLayer.ParsingService do
  @moduledoc false

  alias Core.DomainLayer.UseCases.ParsinfUseCase

  alias Core.DomainLayer.JWTEntity

  @behaviour ParsinfUseCase

  @spec parse(binary(), binary()) :: ParsinfUseCase.ok() | ParsinfUseCase.error()
  def parse(token, secret) do
    JWTEntity.parse(token, secret)
  end
end
