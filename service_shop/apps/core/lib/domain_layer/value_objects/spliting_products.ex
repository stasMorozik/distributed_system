defmodule Core.DomainLayer.ValueObjects.SplitingProdutcs do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Email
  alias Core.DomainLayer.ValueObjects.Amount
  alias Core.DomainLayer.ValueObjects.Price

  alias Core.DomainLayer.ValueObjects.SplitingProdutcs

  defstruct email: nil, ordered: nil, amount: nil, price: nil

  @type t :: %SplitingProdutcs{
          email: Email.t()    | nil,
          ordered: Amount.t() | nil,
          amount: Amount.t()  | nil,
          price: Price.t()    | nil
        }

  @type error ::
          Email.error()
          | Amount.error()
          | Price.error()
          | {:error, ImpossibleCreateError.t()}

  @type ok :: {:ok, SplitingProdutcs.t()}

  @type creating_dto :: %{
          email: binary()   | nil,
          ordered: binary()   | nil,
          amount: binary() | nil,
          price: binary()  | nil
        }

  @spec new(creating_dto()) :: ok() | error()
  def new(%{} = dto) do
    with {:ok, value_email} <- email(dto[:email]),
         {:ok, value_ordered} <- ordered_and_amount(dto[:ordered]),
         {:ok, value_amount} <- ordered_and_amount(dto[:amount]),
         {:ok, value_price} <- price(dto[:price]) do
      {
        :ok,
        %SplitingProdutcs{
          email: value_email,
          ordered: value_ordered,
          amount: value_amount,
          price: value_price
        }
      }
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end


  defp email(email) do
    if email == nil do
      {:ok, nil}
    else
      case Email.new(email) do
        {:ok, value_email} -> {:ok, value_email}
        {:error, error_dto} -> {:error, error_dto}
      end
    end
  end

  defp ordered_and_amount(val) do
    if val == nil do
      {:ok, nil}
    else
      case Amount.new(val) do
        {:ok, value} -> {:ok, value}
        {:error, error_dto} -> {:error, error_dto}
      end
    end
  end

  defp price(price) do
    if price == nil do
      {:ok, nil}
    else
      case Price.new(price) do
        {:ok, value_price} -> {:ok, value_price}
        {:error, error_dto} -> {:error, error_dto}
      end
    end
  end
end
