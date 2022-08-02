defmodule Core.DomainLayer.ValueObjects.Message do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Message
  alias Core.DomainLayer.Errors.DomainError

  defstruct value: nil

  @type t :: %Message{value: binary()}

  @type ok :: {:ok, Message.t()}

  @type error :: {:error, DomainError.t()}

  @spec new(binary()) :: ok() | error()
  def new(mess) when is_binary(mess) do
    if String.length(mess) > 150 do
      {:error, DomainError.new("Message is too long")}
    else
      {:ok, %Message{value: mess}}
    end
  end

  def new(_) do
    {:error, DomainError.new("Message is invalid")}
  end
end
