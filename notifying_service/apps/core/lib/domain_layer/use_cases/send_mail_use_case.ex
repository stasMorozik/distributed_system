defmodule Core.DomainLayer.UseCases.SendMailUseCase do
  @moduledoc false

  alias Core.DomainLayer.Ports.SendMailPort

  alias Core.DomainLayer.NotificationEntity

  @type ok :: {:ok, true}

  @type error :: SendMailPort.error() | NotificationEntity.error_creating()

  @callback send(binary(), binary(), binary(), binary(), SendMailPort.t()) :: ok() | error()
end
