defmodule Core.DomainLayer.ValueObjects.Message do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Message
  alias Core.DomainLayer.Dtos.MessageIsTooLongError
  alias Core.DomainLayer.Dtos.MessageIsInvalidError

  defstruct value: nil

  @type t :: %Message{value: binary()}

  @type ok :: {:ok, Message.t()}

  @type error :: {:error, MessageIsTooLongError.t() | MessageIsInvalidError.t()}

  @spec new(binary()) :: ok() | error()
  def new(mess) when is_binary(mess) do
    if String.length(mess) > 150 do
      {:error, MessageIsTooLongError.new()}
    else
      {:ok, %Message{value: mess}}
    end
  end

  def new(_) do
    {:error, MessageIsInvalidError.new()}
  end
end
