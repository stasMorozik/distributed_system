defmodule Core.CoreDomains.Domains.Password.Dtos.ImpossibleConfirmError do
  alias Core.CoreDomains.Domains.Password.Dtos.ImpossibleConfirmError

  defstruct message: nil

  @type t :: %ImpossibleConfirmError{message: binary}

  @spec new :: ImpossibleConfirmError.t()
  def new() do
    %ImpossibleConfirmError{message: "Impossible confirm password"}
  end
end
