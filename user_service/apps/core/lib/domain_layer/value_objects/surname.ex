defmodule Core.DomainLayer.ValueObjects.Surname do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Surname
  alias Core.DomainLayer.Dtos.SurnameIsInvalidError

  defstruct value: nil

  @type t :: %Surname{value: binary}

  @type ok ::{:ok, Surname.t()}

  @type error :: {:error, SurnameIsInvalidError.t()}

  @spec new(binary) :: ok | error
  def new(surname) when is_binary(surname) do
    case String.match?(surname, ~r/^[a-zA-Z]+$/) do
      true -> {:ok, %Surname{value: surname}}
      false -> {:error, SurnameIsInvalidError.new()}
    end
  end

  def new(_) do
    {:error, SurnameIsInvalidError.new()}
  end
end
