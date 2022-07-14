defmodule Core.DomainLayer.ValueObjects.SortingProducts do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ImpossibleCreateError

  alias Core.DomainLayer.Utils.DefinerSorting
  alias Core.DomainLayer.ValueObjects.Sorting

  @type error :: {:error, ImpossibleCreateError.t()}

  @type ok :: {:ok, Sorting.t()}

  @spec new(Sorting.creating_dto()) :: ok() | error()
  def new(%{
    type: type,
    value: "likes"
  }) do
    case DefinerSorting.define(type) do
      true -> %Sorting{type: type, value: "likes"}
      false -> {:error, ImpossibleCreateError.new()}
    end
  end

  def new(%{
    type: type,
    value: "price"
  }) do
    case DefinerSorting.define(type) do
      true -> %Sorting{type: type, value: "likes"}
      false -> {:error, ImpossibleCreateError.new()}
    end
  end

  def new(%{
    type: type,
    value: "created"
  }) do
    case DefinerSorting.define(type) do
      true -> %Sorting{type: type, value: "likes"}
      false -> {:error, ImpossibleCreateError.new()}
    end
  end

  def new(_) do
    {:error, ImpossibleCreateError.new()}
  end
end
