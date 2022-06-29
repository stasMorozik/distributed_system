defmodule Core.DomainLayer.Domains.Shop.Ports.CreatingPort do
  @moduledoc false

  alias Core.DomainLayer.Common.Dtos.ImpossibleCreateError
  alias Core.DomainLayer.Common.Dtos.IdIsInvalidError
  alias Core.DomainLayer.Common.Dtos.ImpossibleCallError
  alias Core.DomainLayer.Common.Dtos.AlreadyExistsError

  alias Core.DomainLayer.Domains.Shop.ShopEntity

  @type t :: Module

  @type ok :: {:ok, true}

  @type error :: {
          :error,
          ImpossibleCreateError.t()
          | IdIsInvalidError.t()
          | ImpossibleCallError.t()
          | AlreadyExistsError.t()
        }

  @callback create(ShopEntity.t()) :: ok() | error()
end
