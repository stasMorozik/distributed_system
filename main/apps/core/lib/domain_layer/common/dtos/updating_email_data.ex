defmodule Core.DomainLayer.Common.Dtos.UpdatingEmailData do
  @moduledoc false

  alias Core.DomainLayer.Common.Dtos.UpdatingEmailData

  defstruct email: nil, confirming_code: nil

  @type t :: %UpdatingEmailData{
          email: binary(),
          confirming_code: binary(),
        }

  @spec new(binary(), integer()) :: UpdatingEmailData.t()
  def new(email, confirming_code) do
    %UpdatingEmailData{email: email, confirming_code: confirming_code}
  end
end
