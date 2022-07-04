defmodule Core.DomainLayer.UseCases.GettingByEmailUseCase do
  @moduledoc false

  alias Core.DomainLayer.UserEntity

  alias Core.DomainLayer.Ports.GettingByEmailPort

  alias Core.DomainLayer.ValueObjects.Email

  @type ok :: {:ok, UserEntity.t()}

  @type error :: GettingByEmailPort.t() | Email.error()

  @callback get(binary(), binary(), GettingByEmailPort.t()) :: ok() | error()
end
