defmodule Core.DomainLayer.Domains.Buyer.Ports.CreatingPort do
  @moduledoc false

  alias Core.DomainLayer.Common.Dtos.ImpossibleCreateError
  alias Core.DomainLayer.Common.Dtos.IdIsInvalidError
  alias Core.DomainLayer.Common.Dtos.ImpossibleCallError
  alias Core.DomainLayer.Common.Dtos.AlreadyExistsError

  alias Core.DomainLayer.Domains.Buyer.BuyerEntity

  @type t :: Module

  @type ok :: {:ok, BuyerEntity.t()}

  @type error :: {
          :error,
          ImpossibleCreateError.t()
          | IdIsInvalidError.t()
          | ImpossibleCallError.t()
          | AlreadyExistsError.t()
        }

  @callback create(BuyerEntity.t()) :: ok() | error()
end
