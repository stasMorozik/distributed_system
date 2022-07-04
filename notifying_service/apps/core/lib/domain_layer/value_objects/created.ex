defmodule Core.DomainLayer.ValueObjects.Created do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Created

  defstruct value: nil

  @type t :: %Created{value: DateTime.t()}

  @spec new :: Created.t()
  def new do
    %Created{value: DateTime.utc_now()}
  end
end
