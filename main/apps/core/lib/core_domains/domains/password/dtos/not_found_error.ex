defmodule Core.CoreDomains.Domains.Password.Dtos.NotFoundError do
  alias Core.CoreDomains.Domains.Password.Dtos.NotFoundError

  defstruct message: nil

  @type t :: %NotFoundError{message: binary}

  @spec new :: NotFoundError.t()
  def new() do
    %NotFoundError{message: "Password not found"}
  end
end
