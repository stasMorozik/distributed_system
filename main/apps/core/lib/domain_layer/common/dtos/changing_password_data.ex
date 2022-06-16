defmodule Core.DomainLayer.Common.Dtos.ChangingPasswordData do
  @moduledoc false

  alias Core.DomainLayer.Common.Dtos.ChangingPasswordData

  defstruct password: nil, token: nil

  @type t :: %ChangingPasswordData{
          password: binary(),
          token: binary()
        }

  @spec new(binary(), binary()) :: ChangingPasswordData.t()
  def new(password, token) do
    %ChangingPasswordData{password: password, token: token}
  end
end
