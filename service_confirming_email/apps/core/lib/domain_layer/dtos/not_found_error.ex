defmodule Core.DomainLayer.Dtos.NotFoundError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.NotFoundError

  defstruct message: nil

  @type t :: %NotFoundError{message: binary}

  @spec new :: NotFoundError.t()
  def new do
    %NotFoundError{message: "Code not found"}
  end
end
