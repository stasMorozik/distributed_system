defmodule Core.DomainLayer.Common.Dtos.ImpossibleCreateError do
  @moduledoc false

  alias Core.DomainLayer.Common.Dtos.ImpossibleCreateError

  defstruct message: nil

  @type t :: %ImpossibleCreateError{message: binary}

  @spec new(binary) :: ImpossibleCreateError.t()
  def new(message) when is_binary(message) do
    %ImpossibleCreateError{message: message}
  end

  def new(_) do
    %ImpossibleCreateError{
      message: "Impossible create entity"
    }
  end
end
