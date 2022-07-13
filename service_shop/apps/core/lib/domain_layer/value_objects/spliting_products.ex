defmodule Core.DomainLayer.ValueObjects.SplitingProdutcs do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ImpossibleCreateError
  alias Core.DomainLayer.ValueObjects.SplitingProdutcs

  defstruct email: nil, ordered: nil, amount: nil, price: nil

  @type t :: %SplitingProdutcs{
          email: boolean()   | nil,
          ordered: boolean() | nil,
          amount: boolean()  | nil,
          price: boolean()   | nil
        }

  @type error ::
          {:error, ImpossibleCreateError.t()}

  @type ok :: {:ok, SplitingProdutcs.t()}

  @type creating_dto :: %{
          email: boolean()   | nil,
          ordered: boolean() | nil,
          amount: boolean()  | nil,
          price: boolean()   | nil
        }

  @spec new(creating_dto()) :: ok() | error()
  def new(%{
    email: email,
    ordered: ordered,
    amount: amount,
    price: price
  }) do
    {
      :ok,
      %SplitingProdutcs{
        email: email,
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
