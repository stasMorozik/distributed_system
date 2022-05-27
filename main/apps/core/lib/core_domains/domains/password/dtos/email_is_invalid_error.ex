defmodule Core.CoreDomains.Domains.Password.Dtos.EmailIsInvalidError do
  alias Core.CoreDomains.Domains.Password.Dtos.EmailIsInvalidError

  defstruct message: nil

  @type t :: %EmailIsInvalidError{message: binary}

  @spec new :: EmailIsInvalidError.t()
  def new() do
    %EmailIsInvalidError{message: "Email is not valid"}
  end
end
