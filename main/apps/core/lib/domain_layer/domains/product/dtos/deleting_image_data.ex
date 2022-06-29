defmodule Core.DomainLayer.Domains.Product.Dtos.DeletingImageData do
  @moduledoc false

  alias Core.DomainLayer.Domains.Product.Dtos.DeletingImageData

  defstruct id: nil

  @type t :: %DeletingImageData{id: binary()}

  @spec new(binary()) :: DeletingImageData.t()
  def new(id) do
    %DeletingImageData{
      id: id
    }
  end
end
