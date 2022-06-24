defmodule Core.DomainLayer.Common.Dtos.DescriptionIsInvalidError do
  @moduledoc false

  alias Core.DomainLayer.Common.Dtos.DescriptionIsInvalidError

  defstruct message: nil

  @type t :: %DescriptionIsInvalidError{message: binary}

  @spec new(binary()) :: DescriptionIsInvalidError.t()
  def new(mess) when is_binary(mess) do
    %DescriptionIsInvalidError{message: mess}
  end

  def new(_) do
    %DescriptionIsInvalidError{message: "Description is invalid"}
  end
end
