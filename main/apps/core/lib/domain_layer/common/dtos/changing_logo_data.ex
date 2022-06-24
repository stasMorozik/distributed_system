defmodule Core.DomainLayer.Common.Dtos.ChangingLogoData do
  @moduledoc false

  alias Core.DomainLayer.Common.Dtos.ChangingLogoData

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
