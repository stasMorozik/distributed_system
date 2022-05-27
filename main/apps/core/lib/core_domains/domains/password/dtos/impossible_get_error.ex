defmodule Core.CoreDomains.Domains.Password.Dtos.ImpossibleGetError do
  alias Core.CoreDomains.Domains.Password.Dtos.ImpossibleGetError

  defstruct message: nil

  @type t :: %ImpossibleGetError{message: binary}

  @spec new :: ImpossibleGetError.t()
  def new() do
    %ImpossibleGetError{message: "Impossible get password"}
  end
end
