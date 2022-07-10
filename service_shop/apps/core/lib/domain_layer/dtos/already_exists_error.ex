defmodule Core.DomainLayer.Dtos.AlreadyExistsError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.AlreadyExistsError

  defstruct message: nil

  @type t :: %AlreadyExistsError{message: binary}

  @spec new(binary()) :: AlreadyExistsError.t()
  def new(name_entity) do
    %AlreadyExistsError{message: "#{name_entity} address already exists"}
  end
end
