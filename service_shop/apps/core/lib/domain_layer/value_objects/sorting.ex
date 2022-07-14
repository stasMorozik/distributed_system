defmodule Core.DomainLayer.ValueObjects.Sorting do
  @moduledoc false

  defstruct type: nil, value: nil

  alias Core.DomainLayer.ValueObjects.Sorting

  @type t :: %Sorting{
          type: binary(),
          value: binary()
        }

  @type creating_dto :: %{
          type: binary(),
          value: binary()
        }
end
