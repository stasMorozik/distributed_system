defmodule Core.DomainLayer.Domains.Shop.Ports.GettingPort do
  @moduledoc false

  alias Core.DomainLayer.Common.Dtos.IdIsInvalidError
  alias Core.DomainLayer.Common.Dtos.NotFoundError
  alias Core.DomainLayer.Common.Dtos.ImpossibleGetError
  alias Core.DomainLayer.Common.Dtos.ImpossibleCallError

  alias Core.DomainLayer.Domains.Shop.ShopEntity

  @type t :: Module

  @type ok :: {:ok, ShopEntity.t()}

  @type error :: {
          :error,
          IdIsInvalidError.t()
          | NotFoundError.t()
          | ImpossibleGetError.t()
          | ImpossibleCallError.t()
        }

  @callback get(binary()) :: ok() | error()
end
