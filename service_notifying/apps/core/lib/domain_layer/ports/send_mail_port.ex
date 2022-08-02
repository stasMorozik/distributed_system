defmodule Core.DomainLayer.Ports.SendMailPort do
  @moduledoc false

  alias Core.DomainLayer.Errors.InfrastructureError

  alias Core.DomainLayer.NotificationEntity

  @type t :: Module

  @type ok :: {:ok, true}

  @type error :: {:error, InfrastructureError.t()}

  @callback send(NotificationEntity.t()) :: ok() | error()
end
