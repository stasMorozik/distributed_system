defmodule Core.DomainLayer.ConfirmingCodeEntity do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Created
  alias Core.DomainLayer.ValueObjects.Id
  alias Core.DomainLayer.ValueObjects.Email
  alias Core.DomainLayer.ValueObjects.Code

  alias Core.DomainLayer.ConfirmingCodeEntity

  defstruct id: nil, email: nil, code: nil, created: nil

  @type t :: %ConfirmingCodeEntity{
          id: Id.t(),
          email: Email.t(),
          code: Code.t(),
          created: Created.t()
        }
end
