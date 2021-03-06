defmodule Core.DomainLayer.ValueObjects.SplitingCustomerInvoices do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ImpossibleCreateError
  alias Core.DomainLayer.ValueObjects.Splitting

  @type error :: {:error, ImpossibleCreateError.t()}

  @type ok :: {:ok, Splitting.t()}

  @spec new(Splitting.creating_dto()) :: ok() | error()
  def new(%{
    value: "price"
  }) do
    {
      :ok,
      %Splitting{
        value: :price,
        sort: :created
      }
    }
  end

  def new(%{
    value: nil
  }) do
    {:ok, nil}
  end

  def new(_) do
    {:error, ImpossibleCreateError.new()}
  end
end
