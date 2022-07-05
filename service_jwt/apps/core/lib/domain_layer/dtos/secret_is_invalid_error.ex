defmodule Core.DomainLayer.Dtos.SecretIsInvalidError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.SecretIsInvalidError

  defstruct message: nil

  @type t :: %SecretIsInvalidError{message: binary}

  @spec new :: SecretIsInvalidError.t()
  def new do
    %SecretIsInvalidError{message: "Secret key is invalid"}
  end
end
