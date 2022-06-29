defmodule Core.DomainLayer.Domains.User.Dtos.UpdatingPersonalityData do
  @moduledoc false

  alias Core.DomainLayer.Domains.User.Dtos.UpdatingPersonalityData

  defstruct phone: nil, name: nil, surname: nil

  @type t :: %UpdatingPersonalityData{
          phone: any(),
          name: any(),
          surname: any()
        }

  @spec new(any(), any(), any()) :: UpdatingPersonalityData.t()
  def new(name, surname, phone) do
    %UpdatingPersonalityData{name: name, surname: surname, phone: phone}
  end
end
