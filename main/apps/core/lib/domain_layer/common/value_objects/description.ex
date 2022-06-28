defmodule Core.DomainLayer.Common.ValueObjects.Description do
  @moduledoc false

  alias Core.DomainLayer.Common.ValueObjects.Description

  alias Core.DomainLayer.Common.Dtos.DescriptionIsInvalidError

  defstruct value: nil

  @type t :: %Description{value: binary()}

  @type ok :: {:ok, Description.t()}

  @type error :: {:error, DescriptionIsInvalidError.t()}

  @spec new(binary()) :: Description.t()
  def new(text) when is_binary(text) do
    case String.length(text) < 20 do
      true -> {:error, DescriptionIsInvalidError.new("Text is too short for description")}
      false -> {:ok, %Description{value: text}}
    end
  end

  def new(_) do
    {:error, DescriptionIsInvalidError.new()}
  end
end
