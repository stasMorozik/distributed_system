defmodule Core.DomainLayer.Common.ValueObjects.Avatar do
  alias Core.DomainLayer.Common.ValueObjects.Avatar

  defstruct value: nil

  @type t :: %Avatar {
    value: binary
  }

  @spec new(binary) :: Avatar.t()
  def new(image) do
    %Avatar { value: image }
  end
end
