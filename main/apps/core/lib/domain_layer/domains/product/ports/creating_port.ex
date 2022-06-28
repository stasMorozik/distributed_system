defmodule Core.DomainLayer.Domains.Product.Ports.CreatingPort do
  @moduledoc false

  alias Core.DomainLayer.Common.Dtos.ImpossibleCreateError
  alias Core.DomainLayer.Common.Dtos.IdIsInvalidError
  alias Core.DomainLayer.Common.Dtos.ImpossibleCallError
  alias Core.DomainLayer.Common.Dtos.AlreadyExistsError

  alias Core.DomainLayer.Domains.Product.ProductEntity

  @type t :: Module

  @type ok :: {:ok, ProductEntity.t()}

  @type error :: {
          :error,
          ImpossibleCreateError.t()
          | IdIsInvalidError.t()
          | ImpossibleCallError.t()
          | AlreadyExistsError.t()
        }

  @callback create(ProductEntity.t()) :: ok() | error()
end
