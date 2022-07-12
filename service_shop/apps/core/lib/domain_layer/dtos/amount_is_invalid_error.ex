defmodule Core.DomainLayer.Dtos.AmountIsInvalidError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.AmountIsInvalidError

  defstruct message: nil

  @type t :: %AmountIsInvalidError{message: binary}

  @spec new :: AmountIsInvalidError.t()
  def new do
    %AmountIsInvalidError{message: "Amount is invalid"}
  end
end
