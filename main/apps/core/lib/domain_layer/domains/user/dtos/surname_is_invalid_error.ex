defmodule Core.DomainLayer.Domains.User.Dtos.SurnameIsInvalidError do
  alias Core.DomainLayer.Domains.User.Dtos.SurnameIsInvalidError

  defstruct message: nil

  @type t :: %SurnameIsInvalidError{message: binary}

  @spec new() :: SurnameIsInvalidError.t()
  def new do
    %SurnameIsInvalidError{message: "Surname is not valid"}
  end
end
