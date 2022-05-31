defmodule Core.CoreDomains.Domains.Password.Dtos.ImpossibleChangeEmailError do
  alias Core.CoreDomains.Domains.Password.Dtos.ImpossibleChangeEmailError

  defstruct message: nil

  @type t :: %ImpossibleChangeEmailError{message: binary}

  @spec new(binary) :: ImpossibleChangeEmailError.t()
  def new(message) when is_binary(message) do
    %ImpossibleChangeEmailError{message: message}
  end

  def new(_) do
    %ImpossibleChangeEmailError{message: "Impossible change email"}
  end
end
