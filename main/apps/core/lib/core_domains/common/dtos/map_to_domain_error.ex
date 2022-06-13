defmodule Core.CoreDomains.Common.Dtos.MapToDomainError do
  alias Core.CoreDomains.Common.Dtos.MapToDomainError

  defstruct message: nil

  @type t :: %MapToDomainError{message: binary}

  @spec new(binary) :: MapToDomainError.t()
  def new(mess) when is_binary(mess)  do
    %MapToDomainError{message: mess}
  end

  def new(_) do
    %MapToDomainError{message: "Error mapping to domain"}
  end
end
