defmodule Core.DomainLayer.Dtos.StatusIsInvalidError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.StatusIsInvalidError

  defstruct message: nil

  @type t :: %StatusIsInvalidError{message: binary}

  @spec new :: StatusIsInvalidError.t()
  def new do
    %StatusIsInvalidError{message: "Price is invalid"}
  end
end
