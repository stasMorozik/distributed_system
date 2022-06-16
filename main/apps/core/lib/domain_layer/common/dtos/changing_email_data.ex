defmodule Core.DomainLayer.Common.Dtos.ChangingEmailData do
  @moduledoc false

  alias Core.DomainLayer.Common.Dtos.ChangingEmailData

  defstruct email: nil, confirming_code: nil, token: nil

  @type t :: %ChangingEmailData{
          email: binary(),
          confirming_code: binary(),
          token: binary()
        }

  @spec new(binary(), integer(), binary()) :: ChangingEmailData.t()
  def new(email, confirming_code, token) do
    %ChangingEmailData{email: email, confirming_code: confirming_code, token: token}
  end
end
