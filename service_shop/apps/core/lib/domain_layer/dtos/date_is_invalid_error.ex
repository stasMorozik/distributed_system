defmodule Core.DomainLayer.Dtos.DateIsInvalidError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.DateIsInvalidError

  defstruct message: nil

  @type t :: %DateIsInvalidError{message: binary}

  @spec new :: DateIsInvalidError.t()
  def new do
    %DateIsInvalidError{message: "Date is invalid"}
  end
end
