defmodule Core.CoreDomains.Domains.Password.Dtos.PasswordIsNotTrueError do
  alias Core.CoreDomains.Domains.Password.Dtos.PasswordIsNotTrueError

  defstruct message: nil

  @type t :: %PasswordIsNotTrueError{message: binary}

  @spec new :: PasswordIsNotTrueError.t()
  def new() do
    %PasswordIsNotTrueError{message: "Wrong password"}
  end
end
