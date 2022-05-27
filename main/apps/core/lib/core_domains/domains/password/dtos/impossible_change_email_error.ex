defmodule Core.CoreDomains.Domains.Password.Dtos.ImpossibleChangeEmailError do
  alias Core.CoreDomains.Domains.Password.Dtos.ImpossibleChangeEmailError

  defstruct message: nil

  @type t :: %ImpossibleChangeEmailError{message: binary}

  @spec new :: ImpossibleChangeEmailError.t()
  def new() do
    %ImpossibleChangeEmailError{message: "Impossible change email"}
  end
end
