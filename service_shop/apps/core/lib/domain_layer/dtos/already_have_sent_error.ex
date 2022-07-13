defmodule Core.DomainLayer.Dtos.AlreadyHaveSentError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.AlreadyHaveSentError

  defstruct message: nil

  @type t :: %AlreadyHaveSentError{message: binary}

  @spec new :: AlreadyHaveSentError.t()
  def new do
    %AlreadyHaveSentError{message: "Already have paid"}
  end
end
