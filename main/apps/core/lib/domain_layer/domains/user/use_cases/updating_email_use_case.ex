defmodule Core.DomainLayer.Domains.User.UseCases.UpdatingEmailUseCase do
  @moduledoc false

  alias Core.DomainLayer.Domains.User.UserEntity

  alias Core.DomainLayer.Common.Dtos.ChangingEmailData
  alias Core.DomainLayer.Common.Dtos.AuthorizatingData

  alias Core.DomainLayer.Common.Ports.GettingConfirmingCodePort
  alias Core.DomainLayer.Domains.User.Ports.UpdatingPort

  @type t :: Module

  @type ok :: {:ok, UserEntity.t()}

  @type error ::
          UserEntity.error_change_email()
          | GettingConfirmingCodePort.error()
          | UpdatingPort.error()

  @callback update(
              AuthorizatingData.t(),
              ChangingEmailData.t(),
              GettingConfirmingCodePort.t(),
              UpdatingPort.t()
            ) :: ok() | error()
end
