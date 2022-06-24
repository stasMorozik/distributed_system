defmodule Core.DomainLayer.Common.Dtos.AddingImageData do
  @moduledoc false

  alias Core.DomainLayer.Common.Dtos.AddingImageData

  defstruct image: nil

  @type t :: %AddingImageData{image: binary()}

  @spec new(binary()) :: AddingImageData.t()
  def new(image) do
    %AddingImageData{image: image}
  end
end
