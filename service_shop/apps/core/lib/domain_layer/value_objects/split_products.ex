defmodule Core.DomainLayer.ValueObjects.SplitProdutcs do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Email
  alias Core.DomainLayer.ValueObjects.Amount

  alias Core.DomainLayer.ValueObjects.SplitProdutcs

  defstruct email: nil, ordered: nil, amount: nil

  @type t :: %{
          email: Email.t()    | nil,
          ordered: Amount.t() | nil,
          amount: Amount.t()  | nil
        }
end
