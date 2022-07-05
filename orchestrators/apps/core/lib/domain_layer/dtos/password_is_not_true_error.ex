defmodule Core.DomainLayer.Dtos.PasswordIsNotTrueError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.PasswordIsNotTrueError

  defstruct message: nil

  @type t :: %PasswordIsNotTrueError{message: binary}
end
