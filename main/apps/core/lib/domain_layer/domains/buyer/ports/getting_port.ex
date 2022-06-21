defmodule Core.DomainLayer.Domains.Buyer.Ports.GettingPort do
  @moduledoc false

  alias Core.DomainLayer.Common.Dtos.IdIsInvalidError
  alias Core.DomainLayer.Common.Dtos.NotFoundError
  alias Core.DomainLayer.Common.Dtos.ImpossibleGetError
  alias Core.DomainLayer.Common.Dtos.ImpossibleCallError

  alias Core.DomainLayer.Domains.Buyer.BuyerEntity

  @type t :: Module

  @type ok :: {:ok, BuyerEntity.t()}

  @type error :: {
          :error,
          IdIsInvalidError.t()
          | NotFoundError.t()
          | ImpossibleGetError.t()
          | ImpossibleCallError.t()
        }

  @callback get(binary()) :: ok() | error()
end
