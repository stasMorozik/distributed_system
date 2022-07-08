defmodule Core.DomainLayer.Ports.GettingPort do
  @moduledoc false

  alias Core.DomainLayer.Dtos.NotFoundError

  alias Core.DomainLayer.ValueObjects.Id

  alias Core.DomainLayer.UserAggregate

  @type t :: Module

  @type ok :: {:ok, UserAggregate.t()}

  @type error :: {:error, NotFoundError.t()}

  @callback get(Id.t()) :: ok() | error()
end
