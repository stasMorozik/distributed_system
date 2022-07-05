defmodule Core.DomainLayer.JWTEntity do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Token

  alias Core.DomainLayer.JWTEntity

  defstruct token: nil, exchanging_token: nil

  @type t :: %JWTEntity{token: Token.t(), exchanging_token: Token.t()}
end
