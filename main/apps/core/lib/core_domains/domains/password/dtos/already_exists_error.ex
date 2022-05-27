defmodule Core.CoreDomains.Domains.Password.Dtos.AlreadyExistsError do
  alias Core.CoreDomains.Domains.Password.Dtos.AlreadyExistsError

  defstruct message: nil

  @type t :: %AlreadyExistsError{message: binary}

  @spec new :: AlreadyExistsError.t()
  def new() do
    %AlreadyExistsError{message: "Password already exists"}
  end
end
