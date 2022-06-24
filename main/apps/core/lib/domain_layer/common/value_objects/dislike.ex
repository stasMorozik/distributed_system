defmodule Core.DomainLayer.Common.ValueObjects.Dislike do
  @moduledoc false

  alias Core.DomainLayer.Common.ValueObjects.Dislike

  alias Core.DomainLayer.Common.Dtos.ImpossibleCreateError

  defstruct value: nil

  @type t :: %Dislike{value: binary()}

  @type ok :: {:ok, Dislike.t()}

  @type error :: {:error, ImpossibleCreateError.t()}

  @spec new(binary()) :: Dislike.t()
  def new(id_buyer) when is_binary(id_buyer) do
    {:ok, %Dislike{value: id_buyer}}
  end

  def new(_) do
    {:error, ImpossibleCreateError.new("Impossible dislike for invalid data")}
  end
end
