defmodule Core.DomainLayer.Domains.User.UseCases.UpdatingPasswordUseCase do
  @moduledoc false

  alias Core.DomainLayer.Domains.User.UserEntity

  alias Core.DomainLayer.Common.Dtos.UpdatingPasswordData
  alias Core.DomainLayer.Common.Dtos.AuthorizatingData

  alias Core.DomainLayer.Domains.User.Ports.UpdatingPort

  @type t :: Module

  @type ok :: {:ok, UserEntity.t()}

  @type error ::
          UserEntity.error_change_password()
          | UpdatingPort.error()

  @callback update(
              AuthorizatingData.t(),
              UpdatingPasswordData.t(),
              UpdatingPort.t()
            ) :: ok() | error()
end
