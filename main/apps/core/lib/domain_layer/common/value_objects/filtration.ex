defmodule Core.DomainLayer.Common.ValueObjects.Filtration do
  @moduledoc false

  alias Core.DomainLayer.Common.ValueObjects.Filtration

  alias Core.DomainLayer.Common.Dtos.ImpossibleCreateError

  defstruct type: nil, value: nil

  @type t :: %Filtration{
          type: binary(),
          value: binary()
        }

  @type param :: %{
          type: binary(),
          value: binary()
        }

  @spec new(nonempty_list(param())) :: nonempty_list(Filtration.t())
  def new(params) when is_list(params) do
    Enum.filter(params, &condition(&1))
    |> Enum.map(fn %{type: t, value: v} -> %Filtration{type: t, value: v} end)
  end

  def new(_) do
    ImpossibleCreateError.new("Impossible create object of filtration for invalid data")
  end

  @spec condition(param()) :: boolean()
  defp condition(%{type: t, value: _}) do
    cond do
      t == "name" -> true
      true -> false
    end
  end

  defp condition(_) do
    false
  end
end
