defmodule Core.DomainLayer.ValueObjects.ChatName do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.ChatName
  alias Core.DomainLayer.Errors.DomainError

  defstruct value: nil

  @type t :: %ChatName{value: binary}

  @type ok :: {:ok, ChatName.t()}

  @type error :: {:error, DomainError.t()}

  @spec new(binary) :: ok | error
  def new(nm) when is_binary(nm) do
    case String.match?(nm, ~r/^[a-zA-Z]+$/) do
      true -> {:ok, %ChatName{value: nm}}
      false -> {:error, DomainError.new("Name is invalid")}
    end
  end

  def new(_) do
    {:error, DomainError.new("Name is invalid")}
  end
end
