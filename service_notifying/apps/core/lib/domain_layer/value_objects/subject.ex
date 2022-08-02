defmodule Core.DomainLayer.ValueObjects.Subject do
  @moduledoc false

  alias Core.DomainLayer.Errors.DomainError

  alias Core.DomainLayer.ValueObjects.Subject

  defstruct value: nil

  @type t :: %Subject{value: binary()}

  @type ok :: {:ok, Subject.t()}

  @type error :: {:error, DomainError.t()}

  @spec new(binary()) :: ok() | error()
  def new(sub) when is_binary(sub) do
    if String.length(sub) > 20 do
      {:error, DomainError.new("Subject is too long")}
    else
      {:ok, %Subject{value: sub}}
    end
  end

  def new(_) do
    {:error, DomainError.new("Subject is invalid")}
  end
end
