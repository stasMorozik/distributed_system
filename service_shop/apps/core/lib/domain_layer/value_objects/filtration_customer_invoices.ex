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
  }) when is_binary(provider) and is_binary(customer) do
    with {:ok, value_email_p} <- email(provider),
         {:ok, value_email_c} <- email(customer) do
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

  def new(%{
    provider: nil,
    customer: customer
  }) when is_binary(customer) do
    with {:ok, value_email_c} <- email(customer) do
      {
        :ok,
        %FiltrationCustomerInvoices{
          provider: nil,
          customer: value_email_c
        }
      }
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  def new(%{
    provider: provider,
    customer: nil
  }) when is_binary(provider) do
    with {:ok, value_email_p} <- email(provider) do
      {
        :ok,
        %FiltrationCustomerInvoices{
          provider: value_email_p,
          customer: nil
        }
      }
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  def new(%{
    provider: nil,
    customer: nil
  }) do
    {:ok, nil}
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
