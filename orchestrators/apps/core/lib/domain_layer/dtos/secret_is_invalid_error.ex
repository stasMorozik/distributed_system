defmodule Core.DomainLayer.Dtos.SecretIsInvalidError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.SecretIsInvalidError

  defstruct message: nil

  @type t :: %SecretIsInvalidError{message: binary()}
end
