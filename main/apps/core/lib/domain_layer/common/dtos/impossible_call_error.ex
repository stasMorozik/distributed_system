defmodule Core.DomainLayer.Common.Dtos.ImpossibleCallError do
  alias Core.DomainLayer.Common.Dtos.ImpossibleCallError

  defstruct message: nil

  @type t :: %ImpossibleCallError{message: binary}

  @spec new(binary) :: ImpossibleCallError.t()
  def new(message) when is_binary(message) do
    %ImpossibleCallError{message: message}
  end

  def new(_) do
    %ImpossibleCallError{message: "Impossible call method"}
  end
end
