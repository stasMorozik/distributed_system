defmodule Core.DomainLayer.Common.ValueObjects.Image do
  @moduledoc false

  alias Core.DomainLayer.Common.ValueObjects.Image

  defstruct value: nil

  @type t :: %Image{value: binary()}

  @spec new(binary) :: Image.t()
  def new(image) do
    %Image{value: image}
  end
end
