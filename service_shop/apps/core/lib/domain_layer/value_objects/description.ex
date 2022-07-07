defmodule Core.DomainLayer.ValueObjects.Description do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Description
  alias Core.DomainLayer.Dtos.DescriptionIsInvalidError

  defstruct value: nil

  @type t :: %Description{value: integer()}

  @type ok :: {:ok, Description.t()}

  @type error :: {:error, DescriptionIsInvalidError.t()}

  @spec new(binary) :: ok | error
  def new(desc) when is_binary(desc) do
    case byte_size(desc) >= 0 || byte_size(desc) <= 15000 do
      true -> {:ok, %Description{value: desc}}
      false -> {:error, DescriptionIsInvalidError.new()}
    end
  end

  def new(_) do
    {:error, DescriptionIsInvalidError.new()}
  end
end
