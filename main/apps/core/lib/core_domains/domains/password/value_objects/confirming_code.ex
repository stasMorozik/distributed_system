defmodule Core.CoreDomains.Domains.Password.ValueObjects.ConfirmingCode do
  alias Core.CoreDomains.Domains.Password.ValueObjects.ConfirmingCode

  defstruct value: nil

  @type t :: %ConfirmingCode{value: integer}

  @spec new :: ConfirmingCode.t()
  def new() do
    %ConfirmingCode{value: Enum.random(1_000..9_999)}
  end
end
