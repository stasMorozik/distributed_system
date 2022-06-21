defmodule Core.DomainLayer.Domains.User.UseCases.UpdatingPasswordUseCase do
  @moduledoc false

  alias Core.DomainLayer.Domains.User.UserEntity

  alias Core.DomainLayer.Common.Dtos.ChangingPasswordData

  alias Core.DomainLayer.Domains.User.Ports.UpdatingPort

  @type t :: Module

  @type ok :: {:ok, UserEntity.t()}

  @type error :: {
          :error,
          UserEntity.error_change_password()
          | UpdatingPort.error()
        }

  @callback update(
              ChangingPasswordData.t(),
              UpdatingPort.t()
            ) :: ok() | error()
end
