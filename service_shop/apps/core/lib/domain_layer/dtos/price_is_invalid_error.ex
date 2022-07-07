defmodule Core.DomainLayer.Dtos.PriceIsInvalidError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.PriceIsInvalidError

  defstruct message: nil

  @type t :: %PriceIsInvalidError{message: binary}

  @spec new :: PriceIsInvalidError.t()
  def new do
    %PriceIsInvalidError{message: "Price is invalid"}
  end
end
