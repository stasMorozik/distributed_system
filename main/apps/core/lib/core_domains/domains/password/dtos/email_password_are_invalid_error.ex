defmodule Core.CoreDomains.Domains.Password.Dtos.EmailPasswordAreInvalidError do
  alias Core.CoreDomains.Domains.Password.Dtos.EmailPasswordAreInvalidError

  defstruct message: nil

  @type t :: %EmailPasswordAreInvalidError{message: binary}

  @spec new :: EmailPasswordAreInvalidError.t()
  def new() do
    %EmailPasswordAreInvalidError{message: "Password and email are invalid"}
  end
end
