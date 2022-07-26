defmodule Core.DomainLayer.ValueObjects.FiltrationProviderInvoices do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ImpossibleCreateError
  alias Core.DomainLayer.ValueObjects.Email

  alias Core.DomainLayer.ValueObjects.FiltrationProviderInvoices

  defstruct customer: nil, provider: nil

  @type t :: %FiltrationProviderInvoices{
          customer: Email.t() | nil,
          provider: Email.t() | nil,
        }

  @type error ::
          Email.error()
          | {:error, ImpossibleCreateError.t()}

  @type ok :: {:ok, FiltrationProviderInvoices.t()}

  @type creating_dto :: %{
          customer: binary() | nil,
          provider: binary() | nil
        }

  @spec new(creating_dto()) :: ok() | error()
  def new(%{customer: customer, provider: provider}) do
    with {:ok, value_email_customer} <- email(customer),
         {:ok, value_email_provider} <- email(provider) do
      {
        :ok,
        %FiltrationProviderInvoices{
          customer: value_email_customer,
          provider: value_email_provider
        }
      }
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  def new(_) do
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
