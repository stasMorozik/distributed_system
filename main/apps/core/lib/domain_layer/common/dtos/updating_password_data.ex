defmodule Core.DomainLayer.Common.Dtos.UpdatingPasswordData do
  @moduledoc false

  alias Core.DomainLayer.Common.Dtos.UpdatingPasswordData

  defstruct password: nil, token: nil

  @type t :: %UpdatingPasswordData{
          password: binary(),
        }

  @spec new(binary()) :: UpdatingPasswordData.t()
  def new(password) do
    %UpdatingPasswordData{password: password}
  end
end
