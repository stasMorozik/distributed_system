defmodule Core.DomainLayer.Dtos.PasswordIsNotTrueError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.PasswordIsNotTrueError

  defstruct message: nil

  @type t :: %PasswordIsNotTrueError{message: binary}

  @spec new :: PasswordIsNotTrueError.t()
  def new() do
    %PasswordIsNotTrueError{message: "Wrong password"}
  end
end
