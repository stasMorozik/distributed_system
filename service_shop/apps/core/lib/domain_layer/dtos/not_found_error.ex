defmodule Core.DomainLayer.Dtos.NotFoundError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.NotFoundError

  defstruct message: nil

  @type t :: %NotFoundError{message: binary}

  @spec new(binary()) :: NotFoundError.t()
  def new(name_entity) do
    %NotFoundError{message: "#{name_entity} not found"}
  end
end
