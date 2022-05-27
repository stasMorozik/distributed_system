defmodule Core.CoreDomains.Domains.Password.Dtos.ImpossibleCreateError do
  alias Core.CoreDomains.Domains.Password.Dtos.ImpossibleCreateError

  defstruct message: nil

  @type t :: %ImpossibleCreateError{message: binary}

  @spec new :: ImpossibleCreateError.t()
  def new() do
    %ImpossibleCreateError{message: "Impossible create password"}
  end
end
