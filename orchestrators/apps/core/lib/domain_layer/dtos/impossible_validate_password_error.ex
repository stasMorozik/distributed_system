defmodule Core.DomainLayer.Dtos.ImpossibleValidatePasswordError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ImpossibleValidatePasswordError

  defstruct message: nil

  @type t :: %ImpossibleValidatePasswordError{message: binary}
end
