defmodule Core.DomainLayer.Domains.Buyer.Dtos.CreatingData do
  @moduledoc false

  alias Core.DomainLayer.Domains.Buyer.Dtos.CreatingData

  defstruct email: nil,
            password: nil,
            confirming_code: nil

  @type t :: %CreatingData{
          email: binary(),
          password: binary(),
          confirming_code: integer()
        }

  @spec new(binary(), binary(), integer()) :: CreatingData.t()
  def new(email, password, confirming_code) do
    %CreatingData{
      email: email,
      password: password,
      confirming_code: confirming_code
    }
  end
end
