defmodule Core.DomainLayer.Domains.Product.Ports.UpdatingPort do
  @moduledoc false

  alias Core.DomainLayer.Common.Dtos.ImpossibleUpdateError
  alias Core.DomainLayer.Common.Dtos.IdIsInvalidError
  alias Core.DomainLayer.Common.Dtos.ImpossibleCallError

  alias Core.DomainLayer.Domains.Product.ProductEntity

  alias Core.DomainLayer.Common.ValueObjects.Id

  alias Core.DomainLayer.Domains.Product.Dtos.UpdatingData
  alias Core.DomainLayer.Domains.Product.Dtos.AddingImageData
  alias Core.DomainLayer.Domains.Product.Dtos.DeletingImageData

  @type t :: Module

  @type ok :: {:ok, true}

  @type error :: {
          :error,
          ImpossibleUpdateError.t()
          | IdIsInvalidError.t()
          | ImpossibleCallError.t()
        }

  @callback update(Id.t(), UpdatingData.t() | AddingImageData.t() | DeletingImageData.t()) :: ok() | error()
end
