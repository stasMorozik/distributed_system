defmodule Core.DomainLayer.Dtos.ImpossibleValidateError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ImpossibleValidateError

  defstruct message: nil

  @type t :: %ImpossibleValidateError{message: binary}

  @spec new :: ImpossibleValidateError.t()
  def new do
    %ImpossibleValidateError{
      message: "Invalid input data"
    }
  end
end
