defmodule Core.DomainLayer.Common.Dtos.ImpossibleDeleteError do
  @moduledoc false

  alias Core.DomainLayer.Common.Dtos.ImpossibleDeleteError

  defstruct message: nil

  @type t :: %ImpossibleDeleteError{message: binary}

  @spec new(binary) :: ImpossibleDeleteError.t()
  def new(message) when is_binary(message) do
    %ImpossibleDeleteError{message: message}
  end

  def new(_) do
    %ImpossibleDeleteError{
      message: "Impossible delete entity"
    }
  end
end
