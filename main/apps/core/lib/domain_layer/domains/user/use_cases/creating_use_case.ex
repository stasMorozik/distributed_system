defmodule Core.DomainLayer.Domains.User.UseCases.CreatingUseCase do
  @moduledoc false

  alias Core.DomainLayer.Domains.User.UserEntity

  alias Core.DomainLayer.Domains.User.Dtos.CreatingData

  alias Core.DomainLayer.Domains.User.Ports.GettingConfirmingCodePort
  alias Core.DomainLayer.Domains.User.Ports.CreatingPort
  alias Core.DomainLayer.Common.Ports.Notifying

  @type t :: Module

  @type ok :: {:ok, UserEntity.t()}

  @type error :: {
          :error,
          UserEntity.error_creating()
          | GettingConfirmingCodePort.error()
          | CreatingPort.error()
          | Notifying.error()
        }

  @callback create(
              CreatingData.t(),
              GettingConfirmingCodePort.t(),
              CreatingPort.t(),
              Notifying.t()
            ) :: ok() | error()
end
