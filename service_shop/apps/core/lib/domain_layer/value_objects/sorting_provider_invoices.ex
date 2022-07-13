defmodule Core.DomainLayer.ValueObjects.SortingProviderInvoices do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.SortingProviderInvoices
  alias Core.DomainLayer.Dtos.ImpossibleCreateError

  defstruct price: nil, created: nil

  @type t :: %SortingProviderInvoices{
          price: binary()   | nil,
          created: binary() | nil
        }

  @type error :: {:error, ImpossibleCreateError.t()}

  @type ok :: {:ok, SortingProviderInvoices.t()}

  @type creating_dto :: %{
          price: binary()   | nil,
          created: binary() | nil
        }

  @spec new(creating_dto()) :: ok() | error()
  def new(%{
    price: price,
    created: created
  }) do
    with true <- type(price),
         true <- type(created) do
      {
        :ok,
        %SortingProviderInvoices{
          price: price,
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

  defp type(sort) do
    if sort != nil do
      if sort == "ASC" || sort == "DESC" do
        true
      else
        false
      end
    else
      true
    end
  end
end
