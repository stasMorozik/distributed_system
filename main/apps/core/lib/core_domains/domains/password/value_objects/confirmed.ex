defmodule Core.CoreDomains.Domains.Password.ValueObjects.Confirmed do
  alias Core.CoreDomains.Domains.Password.ValueObjects.Confirmed

  defstruct value: nil

  @type t :: %Confirmed{value: boolean}

  @spec new :: Confirmed.t()
  def new() do
    %Confirmed{value: :false}
  end
end
