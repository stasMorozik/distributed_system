defmodule Core.DomainLayer.ValueObjects.FiltrationCustomerInvoices do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ImpossibleCreateError
  alias Core.DomainLayer.ValueObjects.Email

  alias Core.DomainLayer.ValueObjects.FiltrationCustomerInvoices

  defstruct provider: nil

  @type t :: %FiltrationCustomerInvoices{
          provider: Email.t() | nil
        }

  @type error ::
          Email.error()
          | {:error, ImpossibleCreateError.t()}

  @type ok :: {:ok, FiltrationCustomerInvoices.t()}

  @type creating_dto :: %{
          provider: binary() | nil
        }

  @spec new(creating_dto()) :: ok() | error()
  def new(dto) do
    with {:ok, value_email} <- email(dto[:provider]) do
      {
        :ok,
        %FiltrationCustomerInvoices{
          provider: value_email,
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
end
