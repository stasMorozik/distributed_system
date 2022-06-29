defmodule Core.DomainLayer.Domains.Product.Ports.UpdatingPort do
  @moduledoc false

  alias Core.DomainLayer.Common.Dtos.ImpossibleUpdateError
  alias Core.DomainLayer.Common.Dtos.IdIsInvalidError
  alias Core.DomainLayer.Common.Dtos.ImpossibleCallError

  alias Core.DomainLayer.Domains.Product.ProductEntity

  alias Core.DomainLayer.Common.ValueObjects.Id

  alias Core.DomainLayer.Domains.Product.Dtos.UpdatingData

  @type t :: Module

  @type ok :: {:ok, true}

  @type error :: {
          :error,
          ImpossibleUpdateError.t()
          | IdIsInvalidError.t()
          | ImpossibleCallError.t()
        }

  @callback create(Id.t(), UpdatingData.t()) :: ok() | error()
end
