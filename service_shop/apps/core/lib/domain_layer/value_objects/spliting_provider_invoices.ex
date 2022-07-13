defmodule Core.DomainLayer.ValueObjects.SplitingProviderInvoices do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ImpossibleCreateError
  alias Core.DomainLayer.ValueObjects.SplitingProviderInvoices

  defstruct price: nil, created: nil, status: nil, customer: nil

  @type t :: %SplitingProviderInvoices{
          price: boolean()    | nil,
          created: boolean()  | nil,
          status: boolean()   | nil,
          customer: boolean() | nil
        }

  @type error ::
          {:error, ImpossibleCreateError.t()}

  @type ok :: {:ok, SplitingProviderInvoices.t()}

  @type creating_dto :: %{
          created: boolean()  | nil,
          status: boolean()   | nil,
          customer: boolean() | nil,
          price: boolean()    | nil
        }

  @spec new(creating_dto()) :: ok() | error()
  def new(%{
    created: created,
    status: status,
    customer: customer,
    price: price
  }) do
    {
      :ok,
      %SplitingProviderInvoices{
        created: created,
        status: status,
        customer: customer,
        price: price
      }
    }
  end

  def new(_) do
    {:error, ImpossibleCreateError.new()}
  end
end
