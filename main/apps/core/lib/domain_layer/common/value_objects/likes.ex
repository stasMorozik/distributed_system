defmodule Core.DomainLayer.Common.ValueObjects.Like do
  @moduledoc false

  alias Core.DomainLayer.Common.ValueObjects.Like

  alias Core.DomainLayer.Common.Dtos.ImpossibleCreateError

  defstruct value: nil

  @type t :: %Like{value: binary()}

  @type ok :: {:ok, Like.t()}

  @type error :: {:error, ImpossibleCreateError.t()}

  @spec new(binary()) :: Like.t()
  def new(id_buyer) when is_binary(id_buyer) do
    {:ok, %Like{value: id_buyer}}
  end

  def new(_) do
    {:error, ImpossibleCreateError.new("Impossible like for invalid data")}
  end
end
