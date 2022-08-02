defmodule Core.DomainLayer.Errors.DomainError do
  @moduledoc false

  alias Core.DomainLayer.Errors.DomainError

  defstruct message: nil

  @type t :: %DomainError{message: binary}

  @spec new(binary()) :: DomainError.t()
  def new(message) do
    %DomainError{message: message}
  end
end
