defmodule Core.DomainLayer.Dtos.PhoneNumberIsInvalidError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.PhoneNumberIsInvalidError

  defstruct message: nil

  @type t :: %PhoneNumberIsInvalidError{message: binary}
end
