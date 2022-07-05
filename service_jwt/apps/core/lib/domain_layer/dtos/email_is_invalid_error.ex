defmodule Core.DomainLayer.Dtos.EmailIsInvalidError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.EmailIsInvalidError

  defstruct message: nil

  @type t :: %EmailIsInvalidError{message: binary}

  @spec new :: EmailIsInvalidError.t()
  def new do
    %EmailIsInvalidError{message: "Email is invalid"}
  end
end
