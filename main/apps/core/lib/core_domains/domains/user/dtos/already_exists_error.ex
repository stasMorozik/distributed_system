defmodule Core.CoreDomains.Domains.User.Dtos.AlreadyExistsError do
  alias Core.CoreDomains.Domains.User.Dtos.AlreadyExistsError

  defstruct message: nil

  @type t :: %AlreadyExistsError{message: binary}

  @spec new :: AlreadyExistsError.t()
  def new() do
    %AlreadyExistsError{message: "User with this id already exists"}
  end
end
