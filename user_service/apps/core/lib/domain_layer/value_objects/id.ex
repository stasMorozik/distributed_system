defmodule Core.DomainLayer.ValueObjects.Id do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Id

  defstruct value: nil

  @type t :: %Id{value: binary}

  @spec new :: Id.t()
  def new do
    %Id{value: UUID.uuid4()}
  end
end
