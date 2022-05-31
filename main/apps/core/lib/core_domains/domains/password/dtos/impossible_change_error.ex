defmodule Core.CoreDomains.Domains.Password.Dtos.ImpossibleChangeError do
  alias Core.CoreDomains.Domains.Password.Dtos.ImpossibleChangeError

  defstruct message: nil

  @type t :: %ImpossibleChangeError{message: binary}

  @spec new(binary) :: ImpossibleChangeError.t()
  def new(message) when is_binary(message) do
    %ImpossibleChangeError{message: message}
  end

  def new(_) do
    %ImpossibleChangeError{message: "Impossible change password"}
  end
end
