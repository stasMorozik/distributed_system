defmodule Core.DomainLayer.Common.ValueObjects.Sorting do
  @moduledoc false

  alias Core.DomainLayer.Common.ValueObjects.Sorting

  defstruct type: nil, value: nil

  @type t :: %Sorting{
          type: binary(),
          value: binary()
        }

  @type ok :: {
          :ok,
          Sorting.t()
        }

  @type error :: {
          :error,
          ImpossibleCreateError.t()
        }

  @spec new(binary(), binary()) :: ok() | error()
  def new(type, value) when is_binary(type) and is_binary(value) do
    cond do
      type == "name" ->
        {
          :ok,
          %Filtration{
            type: type,
            value: value
          }
        }

      type == "likes" ->
        {
          :ok,
          %Filtration{
            type: type,
            value: value
          }
        }

      type == "created" ->
        {
          :ok,
          %Filtration{
            type: type,
            value: value
          }
        }

      true ->
        {
          :error,
          ImpossibleCreateError.new("Impossible create object of filtration for invalid data")
        }
    end
  end

  def new(_, _) do
    ImpossibleCreateError.new("Impossible create object of sorting for invalid data")
  end
end
