defmodule Core.DomainLayer.Domains.User.UseCases.AuthorizatingUseCase do
  @moduledoc false

  alias Core.DomainLayer.Domains.User.UserEntity

  alias Core.DomainLayer.Domains.User.Ports.GettingPort
  alias Core.DomainLayer.Common.Dtos.AuthorizatingData

  @type t :: Module

  @type ok :: {:ok, UserEntity.t()}

  @type error :: {
          :error,
          GettingPort.error()
          | UserEntity.error_authorizating()
        }

  @callback authorizate(AuthorizatingData.t(), GettingPort.t()) :: ok() | error()
end
