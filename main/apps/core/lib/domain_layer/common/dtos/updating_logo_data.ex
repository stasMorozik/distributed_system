defmodule Core.DomainLayer.Common.Dtos.UpdatingLogoData do
  @moduledoc false

  alias Core.DomainLayer.Common.Dtos.UpdatingLogoData

  defstruct logo: nil

  @type t :: %UpdatingLogoData{
          logo: binary()
        }

  @spec new(binary()) :: UpdatingLogoData.t()
  def new(logo) do
    %UpdatingLogoData{logo: logo}
  end
end
