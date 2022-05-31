defmodule Core.CoreDomains.Domains.Password.Dtos.ImpossibleCreateError do
  alias Core.CoreDomains.Domains.Password.Dtos.ImpossibleCreateError

  defstruct message: nil

  @type t :: %ImpossibleCreateError{message: binary}

  @spec new(binary) :: ImpossibleCreateError.t()
  def new(message) when is_binary(message) do
    %ImpossibleCreateError{message: message}
  end

  def new(_) do
    %ImpossibleCreateError{message: "Impossible create password"}
  end
end
