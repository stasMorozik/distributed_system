defmodule Core.DomainLayer.ValueObjects.SplitingProducts do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ImpossibleCreateError
  alias Core.DomainLayer.ValueObjects.Splitting

  @type error :: {:error, ImpossibleCreateError.t()}

  @type ok :: {:ok, Splitting.t()}

  @spec new(Splitting.creating_dto()) :: ok() | error()
  def new(%{
    value: "provider"
  }) do
    {
      :ok,
      %Splitting{
        value: "provider",
        sort: "price"
      }
    }
  end

  def new(%{
    value: "price"
  }) do
    {
      :ok,
      %Splitting{
        value: "price",
        sort: "likes"
      }
    }
  end

  def new(%{
    value: "amount"
  }) do
    {
      :ok,
      %Splitting{
        value: "amount",
        sort: "price"
      }
    }
  end

  def new(_) do
    {:error, ImpossibleCreateError.new()}
  end
end
