defmodule Core.DomainLayer.ValueObjects.Code do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Code

  defstruct value: nil

  @type t :: %Code{
          value: integer()
        }
end
