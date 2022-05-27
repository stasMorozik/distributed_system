defmodule Core.CoreDomains.Domains.Password.Dtos.MapToDomainError do
  alias Core.CoreDomains.Domains.Password.Dtos.MapToDomainError

  defstruct message: nil

  @type t :: %MapToDomainError{message: binary}

  @spec new :: MapToDomainError.t()
  def new() do
    %MapToDomainError{message: "Error mapping password to domain"}
  end
end
