defmodule Core.DomainLayer.ValueObjects.PhoneNumber do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.PhoneNumber
  alias Core.DomainLayer.Errors.DomainError

  defstruct value: nil

  @type t :: %PhoneNumber{value: binary}

  @type ok :: {:ok, PhoneNumber.t()}

  @type error :: {:error, DomainError.t()}

  @spec new(binary) :: ok | error
  def new(ph) when is_binary(ph) do
    case String.length(ph) >= 5 && String.length(ph) <= 17 do
      false ->
        {:error, DomainError.new("Phone number is invalid")}

      true ->
        case String.match?(ph, ~r/^[0-9]+$/) do
          true -> {:ok, %PhoneNumber{value: ph}}
          false -> {:error, DomainError.new("Phone number is invalid")}
        end
    end
  end

  def new(_) do
    {:error, DomainError.new("Phone number is invalid")}
  end
end
