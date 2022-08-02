defmodule Core.DomainLayer.ValueObjects.Surname do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Surname
  alias Core.DomainLayer.Errors.DomainError

  defstruct value: nil

  @type t :: %Surname{value: binary}

  @type ok ::{:ok, Surname.t()}

  @type error :: {:error, DomainError.t()}

  @spec new(binary) :: ok | error
  def new(surname) when is_binary(surname) do
    case String.match?(surname, ~r/^[a-zA-Z]+$/) do
      true -> {:ok, %Surname{value: surname}}
      false -> {:error, DomainError.new("Surname is invalid")}
    end
  end

  def new(_) do
    {:error, DomainError.new("Surname is invalid")}
  end
end
