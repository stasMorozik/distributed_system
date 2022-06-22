defmodule Core.DomainLayer.Domains.User.UseCases.AuhenticatingUseCase do
  @moduledoc false

  alias Core.DomainLayer.Domains.User.UserEntity

  alias Core.DomainLayer.Common.Dtos.AuthenticatingData
  alias Core.DomainLayer.Domains.User.Ports.GettingPort

  @type t :: Module

  @type ok :: {:ok, binary()}

  @type error ::
          GettingPort.error()
          | UserEntity.error_authenticating()

  @callback authenticate(AuthenticatingData.t(), GettingPort.t()) :: ok() | error()
end
