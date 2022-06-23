defmodule Core.DomainLayer.Domains.Shop.Dtos.CreatingData do
  @moduledoc false

  alias Core.DomainLayer.Domains.Shop.Dtos.CreatingData

  defstruct name: nil,
            logo: nil

  @type t :: %CreatingData{
          name: binary(),
          logo: binary()
        }

  @spec new(binary(), binary()) :: CreatingData.t()
  def new(name, logo) do
    %CreatingData{
      name: name,
      logo: logo
    }
  end
end
