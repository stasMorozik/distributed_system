defmodule Core.DomainLayer.Domains.Product.Ports.GettingPort do
  @moduledoc false

  alias Core.DomainLayer.Common.Dtos.IdIsInvalidError
  alias Core.DomainLayer.Common.Dtos.NotFoundError
  alias Core.DomainLayer.Common.Dtos.ImpossibleGetError
  alias Core.DomainLayer.Common.Dtos.ImpossibleCallError

  alias Core.DomainLayer.Domains.Product.ProductEntity

  alias Core.DomainLayer.Common.ValueObjects.Id

  @type t :: Module

  @type ok :: {:ok, ProductEntity.t()}

  @type error :: {
          :error,
          IdIsInvalidError.t()
          | NotFoundError.t()
          | ImpossibleGetError.t()
          | ImpossibleCallError.t()
        }

  @callback get(Id.t()) :: ok() | error()
end
