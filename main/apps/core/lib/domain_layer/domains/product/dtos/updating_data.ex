defmodule Core.DomainLayer.Domains.Product.Dtos.UpdatingData do
  @moduledoc false

  alias Core.DomainLayer.Domains.Product.Dtos.UpdatingData

  defstruct name: nil,
            description: nil,
            amount: nil

  @type t :: %UpdatingData{
          name: any(),
          description: any(),
          amount: any()
        }

  @spec new(any(), any(), any()) :: UpdatingData.t()
  def new(name, desc, amount) do
    %UpdatingData{
      name: name,
      description: desc,
      amount: amount
    }
  end
end
