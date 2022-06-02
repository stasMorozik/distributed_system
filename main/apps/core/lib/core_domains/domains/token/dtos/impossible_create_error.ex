defmodule Core.CoreDomains.Domains.Token.Dtos.ImpossibleCreateError do
  alias Core.CoreDomains.Domains.Token.Dtos.ImpossibleCreateError

  defstruct message: nil

  @type t :: %ImpossibleCreateError{message: binary}

  @spec new(binary) :: ImpossibleCreateError.t()
  def new(message) when is_binary(message) do
    %ImpossibleCreateError{message: message}
  end

  def new(_) do
    %ImpossibleCreateError{message: "Impossible create token"}
  end
end
