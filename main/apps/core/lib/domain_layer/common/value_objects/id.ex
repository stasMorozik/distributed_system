defmodule Core.DomainLayer.Common.ValueObjects.Id do
  alias Core.DomainLayer.Common.ValueObjects.Id

  defstruct value: nil

  @type t :: %Id{value: binary}

  @spec new :: Id.t()
  def new do
    %Id{value: UUID.uuid4()}
  end
end
