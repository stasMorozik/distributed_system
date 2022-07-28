defmodule Core.DomainLayer.ValueObjects.FiltrationProducts do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ImpossibleCreateError
  alias Core.DomainLayer.ValueObjects.Email
  alias Core.DomainLayer.ValueObjects.Name

  alias Core.DomainLayer.ValueObjects.FiltrationProducts

  defstruct provider: nil, name: nil

  @type t :: %FiltrationProducts{
          provider: Email.t() | nil,
          name: Name.t()   | nil
        }

  @type error ::
          Email.error()
          | Name.error()
          | {:error, ImpossibleCreateError.t()}

  @type ok :: {:ok, FiltrationProducts.t()}

  @type creating_dto :: %{
          provider: binary() | nil,
          name: binary()  | nil
        }

  @spec new(creating_dto()) :: ok() | error()
  def new(%{
    provider: email,
    name: name
  }) when is_binary(email) and is_binary(name) do
    with {:ok, value_email} <- email(email),
         {:ok, value_name} <- name(name) do
      {
        :ok,
        %FiltrationProducts{
          provider: value_email,
          name: value_name
        }
      }
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  def new(%{
    provider: nil,
    name: name
  }) when is_binary(name) do
    with {:ok, value_name} <- name(name) do
      {
        :ok,
        %FiltrationProducts{
          provider: nil,
          name: value_name
        }
      }
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  def new(%{
    provider: email,
    name: nil
  }) when is_binary(email) do
    with {:ok, value_email} <- email(email) do
      {
        :ok,
        %FiltrationProducts{
          provider: value_email,
          name: nil
        }
      }
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  def new(%{
    provider: nil,
    name: nil
  }) do
    {:ok, nil}
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
