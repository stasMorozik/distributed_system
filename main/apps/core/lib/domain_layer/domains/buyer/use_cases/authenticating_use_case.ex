defmodule Core.DomainLayer.Domains.Buyer.UseCases.AuhenticatingUseCase do
  @moduledoc false

  alias Core.DomainLayer.Domains.Buyer.BuyerEntity

  alias Core.DomainLayer.Common.Dtos.AuthenticatingData
  alias Core.DomainLayer.Domains.Buyer.Ports.GettingPort

  @type t :: Module

  @type ok :: {:ok, binary()}

  @type error :: {
          GettingPort.error()
          | BuyerEntity.error_authenticating()
        }

  @callback authenticate(AuthenticatingData.t(), GettingPort.t()) :: ok() | error()
end
