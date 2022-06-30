defmodule Core.DomainLayer.Dtos.ImpossibleValidatePasswordError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ImpossibleValidatePasswordError

  defstruct message: nil

  @type t :: %ImpossibleValidatePasswordError{message: binary}

  @spec new :: ImpossibleValidatePasswordError.t()
  def new do
    %ImpossibleValidatePasswordError{message: "Invalid input data"}
  end
end
