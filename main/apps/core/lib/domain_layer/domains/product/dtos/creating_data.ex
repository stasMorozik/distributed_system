defmodule Core.DomainLayer.Domains.Product.Dtos.CreatingData do
  @moduledoc false

  alias Core.DomainLayer.Domains.Product.Dtos.CreatingData

  defstruct name: nil,
            images: nil

  @type t :: %CreatingData{
          name: binary(),
          images: list(binary())
        }

  @spec new(binary(), list(binary())) :: CreatingData.t()
  def new(name, images) do
    %CreatingData{
      name: name,
      images: images
    }
  end
end
