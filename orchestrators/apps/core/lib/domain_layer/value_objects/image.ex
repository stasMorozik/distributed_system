defmodule Core.DomainLayer.ValueObjects.Image do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Image

  defstruct value: nil, id: nil, created: nil

  @type t :: %Image{value: binary(), id: binary(), created: DateTime.t()}
end
