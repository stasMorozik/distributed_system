defmodule Core.DomainLayer.Dtos.ServiceUnavailableError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ServiceUnavailableError

  defstruct message: nil

  @type t :: %ServiceUnavailableError{message: binary()}

  @spec new(binary()) :: ServiceUnavailableError.t()
  def new(name_service) when is_binary(name_service) do
    %ServiceUnavailableError{message: "Service #{name_service} Unavailable"}
  end

  def new(_) do
    %ServiceUnavailableError{message: "Service Unavailable"}
  end
end
