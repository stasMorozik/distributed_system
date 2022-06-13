defmodule Core.CoreDomains.Common.Dtos.ImpossibleGetError do
  alias Core.CoreDomains.Common.Dtos.ImpossibleGetError

  defstruct message: nil

  @type t :: %ImpossibleGetError{message: binary}

  @spec new(binary) :: ImpossibleGetError.t()
  def new(message) when is_binary(message) do
    %ImpossibleGetError{message: message}
  end

  def new(_) do
    %ImpossibleGetError{message: "Impossible get entity"}
  end
end
