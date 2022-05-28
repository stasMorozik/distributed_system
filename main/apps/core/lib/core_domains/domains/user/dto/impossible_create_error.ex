defmodule Core.CoreDomains.Domains.User.Dtos.ImpossibleCreateError do
  alias Core.CoreDomains.Domains.User.Dtos.ImpossibleCreateError

  defstruct message: nil

  @type t :: %ImpossibleCreateError{message: binary}

  @spec new :: ImpossibleCreateError.t()
  def new() do
    %ImpossibleCreateError{message: "Impossible create user"}
  end
end
