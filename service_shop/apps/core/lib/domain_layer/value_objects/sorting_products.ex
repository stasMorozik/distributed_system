defmodule Core.DomainLayer.ValueObjects.SortingProducts do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.SortingProducts
  alias Core.DomainLayer.Dtos.ImpossibleCreateError

  alias Core.DomainLayer.Utils.DefinerSorting

  defstruct likes: nil, price: nil, ordered: nil, amount: nil, created: nil

  @type t :: %SortingProducts{
          likes: binary()   | nil,
          price: binary()   | nil,
          ordered: binary() | nil,
          amount: binary()  | nil,
          created: binary() | nil
        }

  @type error :: {:error, ImpossibleCreateError.t()}

  @type ok :: {:ok, SortingProducts.t()}

  @type creating_dto :: %{
          likes: binary()   | nil,
          price: binary()   | nil,
          ordered: binary() | nil,
          amount: binary()  | nil,
          created: binary() | nil
        }

  @spec new(creating_dto()) :: ok() | error()
  def new(%{
    likes: likes,
    price: price,
    ordered: ordered,
    amount: amount,
    created: created
  }) do
    with true <- DefinerSorting.define(likes),
         true <- DefinerSorting.define(price),
         true <- DefinerSorting.define(ordered),
         true <- DefinerSorting.define(amount),
         true <- DefinerSorting.define(created) do
      {
        :ok,
        %SortingProducts{
          likes: likes,
          price: price,
          ordered: ordered,
          amount: amount,
          created: created
        }
      }
    else
      false -> {:error, ImpossibleCreateError.new()}
    end
  end

  def new(_) do
    {:error, ImpossibleCreateError.new()}
  end
end
