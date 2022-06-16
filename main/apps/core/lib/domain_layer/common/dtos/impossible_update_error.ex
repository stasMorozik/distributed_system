defmodule Core.DomainLayer.Common.Dtos.ImpossibleUpdateError do
  @moduledoc false

  alias Core.DomainLayer.Common.Dtos.ImpossibleUpdateError

  defstruct message: nil

  @type t :: %ImpossibleUpdateError{message: binary}

  @spec new(binary) :: ImpossibleUpdateError.t()
  def new(message) when is_binary(message) do
    %ImpossibleUpdateError{message: message}
  end

  def new(_) do
    %ImpossibleUpdateError{
      message: "Impossible update entity"
    }
  end
end
