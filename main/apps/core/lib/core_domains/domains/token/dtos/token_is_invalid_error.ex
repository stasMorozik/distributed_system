defmodule Core.CoreDomains.Domains.Token.Dtos.TokenIsInvalidError do
  alias Core.CoreDomains.Domains.Token.Dtos.TokenIsInvalidError

  defstruct message: nil

  @type t :: %TokenIsInvalidError{message: binary}

  @spec new() :: TokenIsInvalidError.t()
  def new do
    %TokenIsInvalidError{message: "Ivalid token"}
  end
end
