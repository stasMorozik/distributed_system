defmodule Core.DomainLayer.Common.ValueObjects.Sorting do
  @moduledoc false

  alias Core.DomainLayer.Common.ValueObjects.Sorting

  alias Core.DomainLayer.Common.Dtos.ImpossibleCreateError

  defstruct type: nil, value: nil

  @type t :: %Sorting{
          type: binary(),
          value: binary()
        }

  @type param :: %{
          type: binary(),
          value: binary()
        }

  @spec new(nonempty_list(param())) :: nonempty_list(Sorting.t())
  def new(params) when is_list(params) do
    Enum.filter(params, &condition(&1))
    |> Enum.map(fn %{type: t, value: v} -> %Sorting{type: t, value: v} end)
  end

  def new(_) do
    ImpossibleCreateError.new("Impossible create object of sorting for invalid data")
  end

  @spec condition(param()) :: boolean()
  defp condition(%{type: t, value: v}) when is_binary(v) do
    cond do
      t == "name" -> true
      t == "likes" -> true
      t == "created" -> true
      true -> false
    end
  end

  defp condition(_) do
    false
  end
end
