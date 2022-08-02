defmodule Core.DomainLayer.Ports.GettingByEmailPort do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Email
  alias Core.DomainLayer.UserAggregate
  alias Core.DomainLayer.Errors.InfrastructureError

  @type t :: Module

  @type ok :: {:ok, UserAggregate.t()}

  @type error :: {:error, InfrastructureError.t()}

  @callback get_by_email(Email.t()) :: ok() | error()
end
