defmodule Core.DomainLayer.Common.Dtos.ChangingAmountData do
  @moduledoc false

  alias Core.DomainLayer.Common.Dtos.ChangingAmountData

  defstruct amount: nil

  @type t :: %ChangingAmountData{
          amount: integer()
        }

  @spec new(integer()) :: ChangingAmountData.t()
  def new(amount) do
    %ChangingAmountData{
      amount: amount
    }
  end
end
