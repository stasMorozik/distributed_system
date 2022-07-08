defmodule Core.DomainLayer.UseCases.GettingByEmailUseCase do
  @moduledoc false

  alias Core.DomainLayer.UserAggregate

  alias Core.DomainLayer.Ports.GettingByEmailPort

  alias Core.DomainLayer.ValueObjects.Email

  @type ok :: {:ok, UserAggregate.t()}

  @type error :: GettingByEmailPort.error() | Email.error()

  @callback get(binary(), binary(), GettingByEmailPort.t()) :: ok() | error()
end
