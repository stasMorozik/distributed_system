defmodule Core.DomainLayer.Common.Dtos.AuthenticatingData do
  @moduledoc false

  alias Core.DomainLayer.Common.Dtos.AuthenticatingData

  defstruct password: nil, email: nil

  @type t :: %AuthenticatingData{password: binary(), email: binary()}

  @spec new(binary(), binary()) :: AuthenticatingData.t()
  def new(password, email) do
    %AuthenticatingData{password: password, email: email}
  end
end
