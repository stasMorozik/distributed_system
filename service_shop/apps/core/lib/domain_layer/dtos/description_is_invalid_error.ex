defmodule Core.DomainLayer.Dtos.DescriptionIsInvalidError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.DescriptionIsInvalidError

  defstruct message: nil

  @type t :: %DescriptionIsInvalidError{message: binary}

  @spec new :: DescriptionIsInvalidError.t()
  def new do
    %DescriptionIsInvalidError{message: "Description is invalid"}
  end
end
