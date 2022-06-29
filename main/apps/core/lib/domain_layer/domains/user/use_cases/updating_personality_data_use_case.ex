defmodule Core.DomainLayer.Domains.User.UseCases.UpdatingPersonalityDataUseCase do
  @moduledoc false

  alias Core.DomainLayer.Domains.User.UserEntity

  alias Core.DomainLayer.Domains.User.Dtos.ChangingPersonalityData
  alias Core.DomainLayer.Common.Dtos.AuthorizatingData

  alias Core.DomainLayer.Domains.User.Ports.UpdatingPort

  @type t :: Module

  @type ok :: {:ok, UserEntity.t()}

  @type error ::
          UserEntity.error_change_personality()
          | UpdatingPort.error()

  @callback update(
              AuthorizatingData.t(),
              ChangingPersonalityData.t(),
              UpdatingPort.t()
            ) :: ok() | error()
end
