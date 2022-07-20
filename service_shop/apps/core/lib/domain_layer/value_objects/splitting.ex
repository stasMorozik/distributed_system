defmodule Core.DomainLayer.ValueObjects.Splitting do
  @moduledoc false

  defstruct value: nil, sort: nil

  alias Core.DomainLayer.ValueObjects.Splitting

  @type t :: %Splitting{
          value: atom(),
          sort: atom()
        }

  @type creating_dto :: %{
          value: binary()
        }
end
