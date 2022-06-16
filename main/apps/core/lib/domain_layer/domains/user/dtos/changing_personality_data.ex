defmodule Core.DomainLayer.Domains.User.Dtos.ChangingPersonalityData do
  @moduledoc false

  alias Core.DomainLayer.Domains.User.Dtos.ChangingPersonalityData

  defstruct phone: nil, name: nil, surname: nil, token: nil

  @type t :: %ChangingPersonalityData{
          phone: any(),
          name: any(),
          surname: any(),
          token: binary()
        }

  @spec new(any(), any(), any(), binary()) :: ChangingPersonalityData.t()
  def new(name, surname, phone, token) do
    %ChangingPersonalityData{name: name, surname: surname, phone: phone, token: token}
  end
end
