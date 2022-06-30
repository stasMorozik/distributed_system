defmodule Core.DomainLayer.ValueObjects.Created do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Created

  defstruct value: nil

  @type t :: %Created{value: NaiveDateTime.t()}

  @spec new :: Created.t()
  def new do
    %Created{value: NaiveDateTime.utc_now()}
  end
end
