defmodule Core.DomainLayer.Common.Dtos.AuthenticatingData do
  @moduledoc false

  alias Core.DomainLayer.Common.Dtos.AuthenticatingData

  defstruct password: nil

  @type t :: %AuthenticatingData{password: binary()}

  @spec new(binary()) :: AuthenticatingData.t()
  def new(password) do
    %AuthenticatingData{password: password}
  end
end
