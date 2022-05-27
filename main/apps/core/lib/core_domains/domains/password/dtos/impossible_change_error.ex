defmodule Core.CoreDomains.Domains.Password.Dtos.ImpossibleChangeError do
  alias Core.CoreDomains.Domains.Password.Dtos.ImpossibleChangeError

  defstruct message: nil

  @type t :: %ImpossibleChangeError{message: binary}

  @spec new :: ImpossibleChangeError.t()
  def new() do
    %ImpossibleChangeError{message: "Impossible change password"}
  end
end
