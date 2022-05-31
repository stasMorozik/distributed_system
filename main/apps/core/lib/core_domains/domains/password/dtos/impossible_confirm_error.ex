defmodule Core.CoreDomains.Domains.Password.Dtos.ImpossibleConfirmError do
  alias Core.CoreDomains.Domains.Password.Dtos.ImpossibleConfirmError

  defstruct message: nil

  @type t :: %ImpossibleConfirmError{message: binary}

  @spec new(binary) :: ImpossibleConfirmError.t()
  def new(message) when is_binary(message) do
    %ImpossibleConfirmError{message: message}
  end

  def new(_) do
    %ImpossibleConfirmError{message: "Impossible confirm email"}
  end
end
