defmodule Core.DomainLayer.ValueObjects.SplitingProviderInvoices do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Price
  alias Core.DomainLayer.ValueObjects.Status
  alias Core.DomainLayer.ValueObjects.Created

  alias Core.DomainLayer.ValueObjects.SplitingProviderInvoices

  defstruct price: nil, created: nil, status: nil

  @type t :: %SplitingProviderInvoices{
          price: Price.t()     | nil,
          created: Created.t() | nil,
          status: Status.t()   | nil
        }

  @type error ::
          Price.error()
          | Status.error()
          | {:error, ImpossibleCreateError.t()}

  @type ok :: {:ok, SplitingProviderInvoices.t()}

  @type creating_dto :: %{
          created: integer()   | nil,
          status: binary()     | nil,
          price: float()       | nil
        }

  @spec new(creating_dto()) :: ok() | error()
  def new(%{} = dto) do
    with {:ok, value_created} <- created(dto[:created]),
         {:ok, value_status} <- status(dto[:status]),
         {:ok, value_price} <- price(dto[:price]) do
      {
        :ok,
        %SplitingProviderInvoices{
          created: value_created,
          status: value_status,
          price: value_price
        }
      }
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end


  defp created(created) do
    if created == nil do
      {:ok, nil}
    else
      case Created.from_unix(created) do
        {:ok, value_created} -> {:ok, value_created}
        {:error, error_dto} -> {:error, error_dto}
      end
    end
  end

  defp status(status) do
    if status == nil do
      {:ok, nil}
    else
      case Status.new(status) do
        {:ok, value_status} -> {:ok, value_status}
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
