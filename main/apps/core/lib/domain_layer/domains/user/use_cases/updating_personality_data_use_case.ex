defmodule Core.DomainLayer.Domains.User.UseCases.UpdatingPersonalityDataUseCase do
  @moduledoc false

  alias Core.DomainLayer.Domains.User.UserEntity

  alias Core.DomainLayer.Domains.User.Dtos.ChangingPersonalityData

  alias Core.DomainLayer.Domains.User.Ports.UpdatingPort

  @type t :: Module

  @type ok :: {:ok, UserEntity.t()}

  @type error :: {
          :error,
          UserEntity.error_change_personality()
          | UpdatingPort.error()
        }

  @callback update(
              ChangingPersonalityData.t(),
              UpdatingPort.t()
            ) :: ok() | error()
end
