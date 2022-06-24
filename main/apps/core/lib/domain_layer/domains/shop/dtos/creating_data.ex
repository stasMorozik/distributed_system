defmodule Core.DomainLayer.Domains.Shop.Dtos.CreatingData do
  @moduledoc false

  alias Core.DomainLayer.Domains.Shop.Dtos.CreatingData

  defstruct name: nil,
            logo: nil,
            description: nil

  @type t :: %CreatingData{
          name: binary(),
          logo: binary(),
          description: binary()
        }

  @spec new(binary(), binary(), binary()) :: CreatingData.t()
  def new(name, logo, desc) do
    %CreatingData{
      name: name,
      logo: logo,
      description: desc
    }
  end
end
