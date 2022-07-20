defmodule Core.DomainLayer.ValueObjects.SortingCustomerInvoices do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ImpossibleCreateError

  alias Core.DomainLayer.ValueObjects.Sorting

  @type error :: {:error, ImpossibleCreateError.t()}

  @type ok :: {:ok, Sorting.t()}

  @spec new(Sorting.creating_dto()) :: ok() | error()
  def new(%{
    type: "ASC",
    value: "price"
  }) do
    %Sorting{type: :asc, value: :price}
  end

  def new(%{
    type: "DESC",
    value: "price"
  }) do
    %Sorting{type: :desc, value: :price}
  end

  def new(%{
    type: "ASC",
    value: "created"
  }) do
    %Sorting{type: :asc, value: :created}
  end

  def new(%{
    type: "DESC",
    value: "created"
  }) do
    %Sorting{type: :desc, value: :created}
  end

  def new(_) do
    {:error, ImpossibleCreateError.new()}
  end
end
