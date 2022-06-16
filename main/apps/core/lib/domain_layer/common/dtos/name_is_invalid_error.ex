defmodule Core.DomainLayer.Common.Dtos.NameIsInvalidError do
  @moduledoc false

  alias Core.DomainLayer.Common.Dtos.NameIsInvalidError

  defstruct message: nil

  @type t :: %NameIsInvalidError{message: binary}

  @spec new() :: NameIsInvalidError.t()
  def new do
    %NameIsInvalidError{message: "Name is not valid"}
  end
end
