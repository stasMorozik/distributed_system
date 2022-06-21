defmodule Core.DomainLayer.Domains.Shop.Dtos.ChangingNameData do
  @moduledoc false

  alias Core.DomainLayer.Domains.Shop.Dtos.ChangingNameData

  defstruct name: nil

  @type t :: %ChangingNameData{
          name: binary()
        }

  @spec new(binary()) :: ChangingNameData.t()
  def new(name) do
    %ChangingNameData{
      name: name
    }
  end
end
