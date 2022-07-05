defmodule Core.DomainLayer.ValueObjects.Subject do
  @moduledoc false

  alias Core.DomainLayer.Dtos.SubjectIsInvalidError

  alias Core.DomainLayer.Dtos.SubjectIsTooLongError

  alias Core.DomainLayer.ValueObjects.Subject

  defstruct value: nil

  @type t :: %Subject{value: binary()}

  @type ok :: {:ok, Subject.t()}

  @type error :: {:error, SubjectIsTooLongError.t() | SubjectIsInvalidError.t()}

  @spec new(binary()) :: ok() | error()
  def new(sub) when is_binary(sub) do
    if String.length(sub) > 20 do
      {:error, SubjectIsTooLongError.new()}
    else
      {:ok, %Subject{value: sub}}
    end
  end

  def new(_) do
    {:error, SubjectIsInvalidError.new()}
  end
end
