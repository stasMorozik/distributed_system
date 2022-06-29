defmodule Core.DomainLayer.Domains.Buyer.Ports.GettingByEmailPort do
  @moduledoc false

  alias Core.DomainLayer.Common.Dtos.EmailIsInvalidError
  alias Core.DomainLayer.Common.Dtos.NotFoundError
  alias Core.DomainLayer.Common.Dtos.ImpossibleGetError
  alias Core.DomainLayer.Common.Dtos.ImpossibleCallError
  alias Core.DomainLayer.Domains.Buyer.BuyerEntity

  alias Core.DomainLayer.Common.ValueObjects.Email

  @type t :: Module

  @type ok :: {:ok, BuyerEntity.t()}

  @type error :: {
        :error,
        EmailIsInvalidError.t()
        | NotFoundError.t()
        | ImpossibleGetError.t()
        | ImpossibleCallError.t()
      }

  @callback get(Email.t()) :: ok() | error()
end
