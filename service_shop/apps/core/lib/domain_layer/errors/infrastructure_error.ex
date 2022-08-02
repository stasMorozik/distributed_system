defmodule Core.DomainLayer.Errors.InfrastructureError do
  @moduledoc false

  alias Core.DomainLayer.Errors.InfrastructureError

  defstruct message: nil

  @type t :: %InfrastructureError{message: binary}

  @spec new(binary()) :: InfrastructureError.t()
  def new(message) do
    %InfrastructureError{message: message}
  end
end
