defmodule Core.DomainLayer.Domains.Buyer.UseCases.UpdatingPasswordUseCase do
  @moduledoc false

  alias Core.DomainLayer.Domains.Buyer.BuyerEntity

  alias Core.DomainLayer.Common.Dtos.ChangingPasswordData
  alias Core.DomainLayer.Common.Dtos.AuthorizatingData

  alias Core.DomainLayer.Domains.Buyer.Ports.UpdatingPort

  @type t :: Module

  @type ok :: {:ok, BuyerEntity.t()}

  @type error ::
          BuyerEntity.error_change_password()
          | UpdatingPort.error()

  @callback update(
              AuthorizatingData.t(),
              ChangingPasswordData.t(),
              UpdatingPort.t()
            ) :: ok() | error()
end
