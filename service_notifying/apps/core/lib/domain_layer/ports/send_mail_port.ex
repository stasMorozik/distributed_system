defmodule Core.DomainLayer.Ports.SendMailPort do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ImpossibleSendError

  alias Core.DomainLayer.NotificationEntity

  @type t :: Module

  @type ok :: {:ok, true}

  @type error :: {:error, ImpossibleSendError.t()}

  @callback send(NotificationEntity.t()) :: ok() | error()
end
