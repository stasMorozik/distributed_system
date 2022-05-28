defmodule Core.CoreDomains.Common.ValueObjects.Created do
  alias Core.CoreDomains.Common.ValueObjects.Created

  defstruct value: nil

  @type t :: %Created {
    value: NaiveDateTime.t()
  }

  @spec new :: Created.t()
  def new do
    %Created { value: NaiveDateTime.utc_now() }
  end
end
