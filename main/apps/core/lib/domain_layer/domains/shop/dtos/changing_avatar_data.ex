defmodule Core.DomainLayer.Domains.Shop.Dtos.ChangingAvatarData do
  @moduledoc false

  alias Core.DomainLayer.Domains.Shop.Dtos.ChangingAvatarData

  defstruct avatar: nil

  @type t :: %ChangingAvatarData{
    avatar: binary()
        }

  @spec new(binary()) :: ChangingAvatarData.t()
  def new(avatar) do
    %ChangingAvatarData{
      avatar: avatar
    }
  end
end
