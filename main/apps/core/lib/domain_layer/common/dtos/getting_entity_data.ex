defmodule Core.DomainLayer.Common.Dtos.GettingEntityData do
  @moduledoc false

  alias Core.DomainLayer.Common.Dtos.GettingEntityData

  defstruct id: nil

  @type t :: %GettingEntityData{id: binary()}

  @spec new(binary()) :: GettingEntityData.t()
  def new(id) do
    %GettingEntityData{id: id}
  end
end
