defmodule Core.DomainLayer.Domains.Buyer.UseCases.UpdatingEmailUseCase do
  @moduledoc false

  alias Core.DomainLayer.Domains.Buyer.BuyerEntity

  alias Core.DomainLayer.Common.Dtos.ChangingEmailData

  alias Core.DomainLayer.Common.Ports.GettingConfirmingCodePort
  alias Core.DomainLayer.Domains.Buyer.Ports.UpdatingPort

  @type t :: Module

  @type ok :: {:ok, BuyerEntity.t()}

  @type error ::
          BuyerEntity.error_change_email()
          | GettingConfirmingCodePort.error()
          | UpdatingPort.error()

  @callback update(
              ChangingEmailData.t(),
              GettingConfirmingCodePort.t(),
              UpdatingPort.t()
            ) :: ok() | error()
end
