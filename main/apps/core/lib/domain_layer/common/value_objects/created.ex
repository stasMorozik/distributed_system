defmodule Core.DomainLayer.Common.ValueObjects.Created do
  alias Core.DomainLayer.Common.ValueObjects.Created

  defstruct value: nil

  @type t :: %Created {
    value: NaiveDateTime.t()
  }

  @spec new :: Created.t()
  def new do
    %Created { value: NaiveDateTime.utc_now() }
  end
end
