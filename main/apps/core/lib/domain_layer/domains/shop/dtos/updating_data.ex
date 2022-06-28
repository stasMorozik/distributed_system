defmodule Core.DomainLayer.Domains.Shop.Dtos.UpdatingData do
  @moduledoc false

  alias Core.DomainLayer.Domains.Shop.Dtos.UpdatingData

  defstruct name: nil,
            description: nil

  @type t :: %UpdatingData{
              name: any(),
              description: any()
            }

  @spec new(any(), any()) :: UpdatingData.t()
  def new(name, desc) do
    %UpdatingData{
      name: name,
      description: desc
    }
  end
end
