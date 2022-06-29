defmodule Core.DomainLayer.Domains.Product.Dtos.AddingImageData do
  @moduledoc false

  alias Core.DomainLayer.Domains.Product.Dtos.AddingImageData

  defstruct images: nil

  @type t :: %AddingImageData{images: list(binary())}

  @spec new(list(binary())) :: AddingImageData.t()
  def new(images) do
    %AddingImageData{
      images: images
    }
  end
end
