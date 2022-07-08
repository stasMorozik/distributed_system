defmodule Core.DomainLayer.ValueObjects.Image do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Image
  alias Core.DomainLayer.Dtos.ImageIsInvalidError

  defstruct value: nil

  @type t :: %Image{value: binary()}

  @type ok :: {:ok, Image.t()}

  @type error :: {:error, ImageIsInvalidError.t()}

  @spec new(binary) :: ok() | error
  def new(image) when is_binary(image) do
    if byte_size(image) > 150000 do
      {:error, ImageIsInvalidError.new()}
    else
      {
        :ok,
        %Image{value: image}
      }
    end
  end

  def new(_) do
    {:error, ImageIsInvalidError.new()}
  end
end
