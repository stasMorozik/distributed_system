defmodule Core.CoreDomains.Domains.Password.Dtos.ImpossibleValidateError do
  alias Core.CoreDomains.Domains.Password.Dtos.ImpossibleValidateError

  defstruct message: nil

  @type t :: %ImpossibleValidateError{message: binary}

  @spec new(binary) :: ImpossibleValidateError.t()
  def new(message) when is_binary(message)  do
    %ImpossibleValidateError{message: message}
  end

  def new(_) do
    %ImpossibleValidateError{message: "Impossible validate password"}
  end
end
