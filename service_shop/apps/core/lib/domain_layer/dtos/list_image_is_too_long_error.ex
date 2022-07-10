defmodule Core.DomainLayer.Dtos.ListImageIsTooLongError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ListImageIsTooLongError

  defstruct message: nil

  @type t :: %ListImageIsTooLongError{message: binary}

  @spec new :: ListImageIsTooLongError.t()
  def new do
    %ListImageIsTooLongError{message: "You have reached the image list limit"}
  end
end
