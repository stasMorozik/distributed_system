defmodule Core.DomainLayer.Common.ValueObjects.Likes do
  @moduledoc false

  alias Core.DomainLayer.Common.ValueObjects.Likes

  defstruct value: nil

  @type t :: %Likes{value: integer()}

  @spec new(integer()) :: Likes.t()
  def new(amount) when is_integer(amount) do
    case amount < 0 do
      :true -> %Likes{value: 0}
      :false -> %Likes{value: amount}
    end
  end

  def new(_) do
    %Likes{value: 0}
  end
end
