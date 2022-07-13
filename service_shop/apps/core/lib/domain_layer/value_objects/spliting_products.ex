defmodule Core.DomainLayer.ValueObjects.SplitingProdutcs do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ImpossibleCreateError
  alias Core.DomainLayer.ValueObjects.SplitingProdutcs

  defstruct provider: nil, ordered: nil, amount: nil, price: nil

  @type t :: %SplitingProdutcs{
          provider: boolean()   | nil,
          ordered: boolean() | nil,
          amount: boolean()  | nil,
          price: boolean()   | nil
        }

  @type error ::
          {:error, ImpossibleCreateError.t()}

  @type ok :: {:ok, SplitingProdutcs.t()}

  @type creating_dto :: %{
          provider: boolean()   | nil,
          ordered: boolean() | nil,
          amount: boolean()  | nil,
          price: boolean()   | nil
        }

  @spec new(creating_dto()) :: ok() | error()
  def new(%{
    provider: provider,
    ordered: ordered,
    amount: amount,
    price: price
  }) do
    {
      :ok,
      %SplitingProdutcs{
        provider: provider,
        ordered: ordered,
        amount: amount,
        price: price
      }
    }
  end

  def new(_) do
    {:error, ImpossibleCreateError.new()}
  end
end
