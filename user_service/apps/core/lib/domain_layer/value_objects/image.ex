defmodule Core.DomainLayer.ValueObjects.Image do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Image
  alias Core.DomainLayer.Dtos.ImageIsInvalidError

  defstruct value: nil, id: nil, created: nil

  @type t :: %Image{value: binary(), id: binary(), created: DateTime.t()}

  @type ok :: {:ok, Image.t()}

  @type error :: {:error, ImageIsInvalidError.t()}

  @spec new(binary) :: ok() | error
  def new(image) when is_binary(image) do
    if byte_size(image) > 150000 do
      {:error, ImageIsInvalidError.new()}
    else
      {
        :ok,
        %Image{value: image, id: UUID.uuid4(), created: DateTime.utc_now()}
      }
    end
  end

  def new(_) do
    {:error, ImageIsInvalidError.new()}
  end

  @spec from_origin(binary(), binary()) :: ok() | error
  def from_origin(id, image) when is_binary(image) and is_binary(id) do
    with {:ok, _} <- UUID.info(id),
         true <- byte_size(image) <= 150000 do
      {
        :ok,
        %Image{value: image, id: id, created: DateTime.utc_now()}
      }
    else
      {:error, error_dto} -> {:error, error_dto}
      false -> {:error, ImageIsInvalidError.new()}
    end
  end

  def from_origin(_, _) do
    {:error, ImageIsInvalidError.new()}
  end
end
