defmodule Core.DomainLayer.Dtos.PasswordIsInvalidError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.PasswordIsInvalidError

  defstruct message: nil

  @type t :: %PasswordIsInvalidError{message: binary}
end
