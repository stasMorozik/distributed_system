defmodule Core.DomainLayer.Domains.Product.Dtos.CreatingData do
  @moduledoc false

  alias Core.DomainLayer.Domains.Product.Dtos.CreatingData

  defstruct name: nil,
            logo: nil,
            images: nil,
            description: nil,
            amount: nil

  @type t :: %CreatingData{
          name: binary(),
          logo: binary(),
          images: list(binary()),
          description: binary(),
          amount: integer()
        }

  @spec new(binary(), binary(), list(binary()), binary(), integer()) :: CreatingData.t()
  def new(name, logo, images, desc, amount) do
    %CreatingData{
      name: name,
      logo: logo,
      images: images,
      description: desc,
      amount: amount
    }
  end
end
