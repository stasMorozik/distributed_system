defmodule Core.DomainLayer.ValueObjects.Image do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Image
  alias Core.DomainLayer.Errors.DomainError

  defstruct value: nil

  @type t :: %Image{value: binary()}

  @type ok :: {:ok, Image.t()}

  @type error :: {:error, DomainError.t()}

  @spec new(binary) :: ok() | error
  def new(image) when is_binary(image) do
    if byte_size(image) > 150000 do
      {:error, DomainError.new("Image size is too long")}
    else
      {
        :ok,
        %Image{value: image}
      }
    end
  end

  def new(_) do
    {:error, DomainError.new("Image is invalid")}
  end
end
