defmodule Core.DomainLayer.Common.AmountIsInvalidError do
  @moduledoc false

  alias Core.DomainLayer.Common.AmountIsInvalidError

  defstruct message: nil

  @type t :: %AmountIsInvalidError{message: binary}

  @spec new :: AmountIsInvalidError.t()
  def new() do
    %AmountIsInvalidError{message: "Amount is invalid"}
  end
end
