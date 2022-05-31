defmodule Core.CoreDomains.Domains.Password.Dtos.ImpossibleGetError do
  alias Core.CoreDomains.Domains.Password.Dtos.ImpossibleGetError

  defstruct message: nil

  @type t :: %ImpossibleGetError{message: binary}

  @spec new(binary) :: ImpossibleGetError.t()
  def new(message) when is_binary(message) do
    %ImpossibleGetError{message: message}
  end

  def new(_) do
    %ImpossibleGetError{message: "Impossible get password"}
  end
end
