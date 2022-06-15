defmodule Core.DomainLayer.Common.Dtos.PhoneNumberIsInvalidError do
  alias Core.DomainLayer.Common.Dtos.PhoneNumberIsInvalidError

  defstruct message: nil

  @type t :: %PhoneNumberIsInvalidError{message: binary}

  @spec new() :: PhoneNumberIsInvalidError.t()
  def new do
    %PhoneNumberIsInvalidError{message: "Phone number is not valid"}
  end
end
