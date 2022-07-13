defmodule Core.DomainLayer.ValueObjects.FiltrationProviderInvoicess do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ImpossibleCreateError
  alias Core.DomainLayer.ValueObjects.Email

  alias Core.DomainLayer.ValueObjects.FiltrationProviderInvoicess

  defstruct customer: nil

  @type t :: %FiltrationProviderInvoicess{
          customer: Email.t() | nil
        }

  @type error ::
          Email.error()
          | {:error, ImpossibleCreateError.t()}

  @type ok :: {:ok, FiltrationProviderInvoicess.t()}

  @spec new(binary() | nil) :: ok() | error()
  def new(email) do
    with {:ok, value_email} <- email(email) do
      {
        :ok,
        %FiltrationProviderInvoicess{
          customer: value_email,
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
