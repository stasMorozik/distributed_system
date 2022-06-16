defmodule Core.DomainLayer.Common.Dtos.ImpossibleAuthenticateError do
  @moduledoc false

  alias Core.DomainLayer.Common.Dtos.ImpossibleAuthenticateError

  defstruct message: nil

  @type t :: %ImpossibleAuthenticateError{message: binary}

  @spec new(binary()) :: ImpossibleAuthenticateError.t()
  def new(mess) when is_binary(mess) do
    %ImpossibleAuthenticateError{message: mess}
  end

  def new(_) do
    %ImpossibleAuthenticateError{
      message: "Error creating authentication token"
    }
  end
end
