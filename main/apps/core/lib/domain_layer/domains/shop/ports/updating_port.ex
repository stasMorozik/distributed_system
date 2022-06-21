defmodule Core.DomainLayer.Domains.Shop.Ports.UpdatingPort do
  @moduledoc false

  alias Core.DomainLayer.Common.Dtos.ImpossibleUpdateError
  alias Core.DomainLayer.Common.Dtos.IdIsInvalidError
  alias Core.DomainLayer.Common.Dtos.ImpossibleCallError
  alias Core.DomainLayer.Common.Dtos.AlreadyExistsError

  alias Core.DomainLayer.Domains.Shop.ShopEntity

  @type t :: Module

  @type ok :: {:ok, ShopEntity.t()}

  @type error :: {
          :error,
          ImpossibleUpdateError.t()
          | IdIsInvalidError.t()
          | ImpossibleCallError.t()
          | AlreadyExistsError.t()
        }

  @callback create(ShopEntity.t()) :: ok() | error()
end
