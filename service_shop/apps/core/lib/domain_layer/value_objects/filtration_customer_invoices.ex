defmodule Core.DomainLayer.ValueObjects.FiltrationCustomerInvoices do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ImpossibleCreateError
  alias Core.DomainLayer.ValueObjects.Email

  alias Core.DomainLayer.ValueObjects.FiltrationCustomerInvoices

  defstruct provider: nil, customer: nil

  @type t :: %FiltrationCustomerInvoices{
          provider: Email.t() | nil,
          customer: Email.t() | nil
        }

  @type error ::
          Email.error()
          | {:error, ImpossibleCreateError.t()}

  @type ok :: {:ok, FiltrationCustomerInvoices.t()}

  @type creating_dto :: %{
          provider: binary() | nil,
          customer: binary() | nil
        }

  @spec new(creating_dto()) :: ok() | error()
  def new(%{
    provider: provider,
    customer: customer
  }) do
    with {:ok, value_email_c} <- email(provider),
         {:ok, value_email_p} <- email(customer) do
      {
        :ok,
        %FiltrationCustomerInvoices{
          provider: value_email_p,
          customer: value_email_c
        }
      }
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  def new() do
    {:error, ImpossibleCreateError.new()}
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
end
