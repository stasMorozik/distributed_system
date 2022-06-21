defmodule Core.DomainLayer.Domains.Buyer.UseCases.UpdatingPasswordUseCase do
  @moduledoc false

  alias Core.DomainLayer.Domains.Buyer.BuyerEntity

  alias Core.DomainLayer.Common.Dtos.ChangingPasswordData

  alias Core.DomainLayer.Domains.Buyer.Ports.UpdatingPort

  @type t :: Module

  @type ok :: {:ok, BuyerEntity.t()}

  @type error :: {
          :error,
          BuyerEntity.error_change_password()
          | UpdatingPort.error()
        }

  @callback update(
              ChangingPasswordData.t(),
              UpdatingPort.t()
            ) :: ok() | error()
end
