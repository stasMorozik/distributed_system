defmodule Core.DomainLayer.ValueObjects.FiltrationProducts do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ImpossibleCreateError
  alias Core.DomainLayer.ValueObjects.Email
  alias Core.DomainLayer.ValueObjects.Name

  alias Core.DomainLayer.ValueObjects.FiltrationProducts

  defstruct email: nil, name: nil

  @type t :: %FiltrationProducts{
          email: Email.t() | nil,
          name: Name.t()   | nil
        }

  @type error ::
          Email.error()
          | Name.error()
          | {:error, ImpossibleCreateError.t()}

  @type ok :: {:ok, FiltrationProducts.t()}

  @spec new(binary() | nil, binary() | nil) :: ok() | error()
  def new(email, name) do
    with {:ok, value_email} <- email(email),
         {:ok, value_name} <- name(name) do
      {
        :ok,
        %FiltrationProducts{
          email: value_email,
          name: value_name
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

  defp name(name) do
    if name == nil do
      {:ok, nil}
    else
      case Name.new(name) do
        {:ok, value_name} -> {:ok, value_name}
        {:error, error_dto} -> {:error, error_dto}
      end
    end
  end
end
