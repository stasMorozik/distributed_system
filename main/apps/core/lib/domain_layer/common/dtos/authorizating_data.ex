defmodule Core.DomainLayer.Common.Dtos.AuthorizatingData do
  @moduledoc false

  alias Core.DomainLayer.Common.Dtos.AuthorizatingData

  defstruct token: nil

  @type t :: %AuthorizatingData{token: binary()}

  @spec new(binary()) :: AuthorizatingData.t()
  def new(token) do
    %AuthorizatingData{token: token}
  end
end
