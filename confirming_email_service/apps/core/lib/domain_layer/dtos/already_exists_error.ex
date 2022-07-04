defmodule Core.DomainLayer.Dtos.AlreadyExistsError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.AlreadyExistsError

  defstruct message: nil

  @type t :: %AlreadyExistsError{message: binary}

  @spec new :: AlreadyExistsError.t()
  def new do
    %AlreadyExistsError{message: "A code with this email address already exists you can send it later in 5 minutes"}
  end
end
