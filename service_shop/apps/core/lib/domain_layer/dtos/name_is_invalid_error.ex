defmodule Core.DomainLayer.Dtos.NameIsInvalidError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.NameIsInvalidError

  defstruct message: nil

  @type t :: %NameIsInvalidError{message: binary}

  @spec new :: NameIsInvalidError.t()
  def new do
    %NameIsInvalidError{message: "Name is invalid"}
  end
end
