defmodule Core.DomainLayer.Domains.Shop.Dtos.CreatingData do
  @moduledoc false

  alias Core.DomainLayer.Domains.Shop.Dtos.CreatingData

  defstruct name: nil,
            avatar: nil

  @type t :: %CreatingData{
          name: binary(),
          avatar: binary()
        }

  @spec new(binary(), binary()) :: CreatingData.t()
  def new(name, avatar) do
    %CreatingData{
      name: name,
      avatar: avatar
    }
  end
end
