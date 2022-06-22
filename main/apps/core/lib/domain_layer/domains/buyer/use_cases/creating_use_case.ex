defmodule Core.DomainLayer.Domains.User.UseCases.CreatingUseCase do
  @moduledoc false

  alias Core.DomainLayer.Domains.Buyer.BuyerEntity

  alias Core.DomainLayer.Domains.Buyer.Dtos.CreatingData

  alias Core.DomainLayer.Common.Ports.GettingConfirmingCodePort
  alias Core.DomainLayer.Common.Ports.Notifying

  alias Core.DomainLayer.Domains.Buyer.Ports.CreatingPort

  @type t :: Module

  @type ok :: {:ok, BuyerEntity.t()}

  @type error ::
          BuyerEntity.error_creating()
          | GettingConfirmingCodePort.error()
          | CreatingPort.error()

  @callback create(
              CreatingData.t(),
              GettingConfirmingCodePort.t(),
              CreatingPort.t(),
              Notifying.t()
            ) :: ok() | error()
end
