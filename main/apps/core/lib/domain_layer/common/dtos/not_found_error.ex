defmodule Core.DomainLayer.Common.Dtos.NotFoundError do
  @moduledoc false

  alias Core.DomainLayer.Common.Dtos.NotFoundError

  defstruct message: nil

  @type t :: %NotFoundError{message: binary}

  @spec new(binary) :: NotFoundError.t()
  def new(mess) when is_binary(mess) do
    %NotFoundError{message: mess}
  end

  def new(_) do
    %NotFoundError{message: "Entity not found"}
  end
end
