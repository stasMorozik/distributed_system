defmodule Core.DomainLayer.Domains.Shop.Dtos.ChangingLogoData do
  @moduledoc false

  alias Core.DomainLayer.Domains.Shop.Dtos.ChangingLogoData

  defstruct logo: nil

  @type t :: %ChangingLogoData{
          logo: binary()
        }

  @spec new(binary()) :: ChangingLogoData.t()
  def new(logo) do
    %ChangingLogoData{
      logo: logo
    }
  end
end
