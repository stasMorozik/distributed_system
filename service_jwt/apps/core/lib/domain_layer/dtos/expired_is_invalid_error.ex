defmodule Core.DomainLayer.Dtos.ExpiredIsInvalidError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ExpiredIsInvalidError

  defstruct message: nil

  @type t :: %ExpiredIsInvalidError{message: binary}

  @spec new :: ExpiredIsInvalidError.t()
  def new do
    %ExpiredIsInvalidError{message: "Expired is invalid"}
  end
end
