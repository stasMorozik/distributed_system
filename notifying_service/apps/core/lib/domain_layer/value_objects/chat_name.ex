defmodule Core.DomainLayer.ValueObjects.ChatName do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.ChatName
  alias Core.DomainLayer.Dtos.NameIsInvalidError

  defstruct value: nil

  @type t :: %ChatName{value: binary}

  @type ok :: {:ok, ChatName.t()}

  @type error :: {:error, NameIsInvalidError.t()}

  @spec new(binary) :: ok | error
  def new(nm) when is_binary(nm) do
    case String.match?(nm, ~r/^[a-zA-Z]+$/) do
      true -> {:ok, %ChatName{value: nm}}
      false -> {:error, NameIsInvalidError.new()}
    end
  end

  def new(_) do
    {:error, NameIsInvalidError.new()}
  end
end
