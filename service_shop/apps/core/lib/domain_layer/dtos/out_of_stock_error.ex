defmodule Core.DomainLayer.Dtos.OutOfStockError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.OutOfStockError

  defstruct message: nil

  @type t :: %OutOfStockError{message: binary}

  @spec new(binary()) :: OutOfStockError.t()
  def new(name) do
    %OutOfStockError{message: "We have not this amount of #{name}"}
  end
end
