defmodule Core.DomainLayer.ValueObjects.SplitingCustomerInvoices do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ImpossibleCreateError
  alias Core.DomainLayer.ValueObjects.Splitting

  @type error :: {:error, ImpossibleCreateError.t()}

  @type ok :: {:ok, Splitting.t()}

  @spec new(Splitting.creating_dto()) :: ok() | error()
  def new(%{
    value: "created"
  }) do
    {
      :ok,
      %Splitting{
        value: "created",
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
        sort: "created"
      }
    }
  end

  def new(_) do
    {:error, ImpossibleCreateError.new()}
  end
end
