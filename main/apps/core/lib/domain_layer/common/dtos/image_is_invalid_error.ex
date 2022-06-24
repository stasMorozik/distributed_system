defmodule Core.DomainLayer.Common.Dtos.ImageIsInvalidError do
  @moduledoc false

  alias Core.DomainLayer.Common.Dtos.ImageIsInvalidError

  defstruct message: nil

  @type t :: %ImageIsInvalidError{message: binary}

  @spec new :: ImageIsInvalidError.t()
  def new() do
    %ImageIsInvalidError{message: "Image is not valid"}
  end
end
