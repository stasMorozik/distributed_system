defmodule Core.DomainLayer.Domains.Buyer.UseCases.AuthorizatingUseCase do
  @moduledoc false

  alias Core.DomainLayer.Domains.Buyer.BuyerEntity

  alias Core.DomainLayer.Domains.Buyer.Ports.GettingPort
  alias Core.DomainLayer.Common.Dtos.AuthorizatingData

  @type t :: Module

  @type ok :: {:ok, BuyerEntity.t()}

  @type error ::
          GettingPort.error()
          | UserEntity.error_authorizating()

  @callback authorizate(AuthorizatingData.t(), GettingPort.t()) :: ok() | error()
end
