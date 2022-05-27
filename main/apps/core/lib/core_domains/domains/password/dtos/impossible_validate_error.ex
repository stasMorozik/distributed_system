defmodule Core.CoreDomains.Domains.Password.Dtos.ImpossibleValidateError do
  alias Core.CoreDomains.Domains.Password.Dtos.ImpossibleValidateError

  defstruct message: nil

  @type t :: %ImpossibleValidateError{message: binary}

  @spec new :: ImpossibleValidateError.t()
  def new() do
    %ImpossibleValidateError{message: "Impossible validate password"}
  end
end
