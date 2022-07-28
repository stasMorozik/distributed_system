defmodule Core.DomainLayer.ValueObjects.SortingProducts do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ImpossibleCreateError

  alias Core.DomainLayer.ValueObjects.Sorting

  @type error :: {:error, ImpossibleCreateError.t()}

  @type ok :: {:ok, Sorting.t()}

  @spec new(Sorting.creating_dto()) :: ok() | error()
  def new(%{
    type: "ASC",
    value: "likes"
  }) do
    {:ok, %Sorting{type: :asc, value: :likes}}
  end

  def new(%{
    type: "DESC",
    value: "likes"
  }) do
    {:ok, %Sorting{type: :desc, value: :likes}}
  end

  def new(%{
    type: "ASC",
    value: "price"
  }) do
    {:ok, %Sorting{type: :asc, value: :price}}
  end

  def new(%{
    type: "DESC",
    value: "price"
  }) do
    {:ok, %Sorting{type: :desc, value: :price}}
  end

  def new(%{
    type: "ASC",
    value: "created"
  }) do
    {:ok, %Sorting{type: :asc, value: :created}}
  end

  def new(%{
    type: "DESC",
    value: "created"
  }) do
    {:ok, %Sorting{type: :desc, value: :created}}
  end

  def new(%{
    type: nil,
    value: nil
  }) do
    {:ok, nil}
  end

  def new(_) do
    {:error, ImpossibleCreateError.new()}
  end
end
