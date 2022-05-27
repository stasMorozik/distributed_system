defmodule Core.CoreDomains.Domains.Password.Dtos.ImpossibleDeleteError do
  alias Core.CoreDomains.Domains.Password.Dtos.ImpossibleDeleteError

  defstruct message: nil

  @type t :: %ImpossibleDeleteError{message: binary}

  @spec new :: ImpossibleDeleteError.t()
  def new() do
    %ImpossibleDeleteError{message: "Impossible delete password"}
  end
end
