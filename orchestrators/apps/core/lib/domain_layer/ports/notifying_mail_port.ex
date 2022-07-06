defmodule Core.DomainLayer.Ports.NotifyingMailPort do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ServiceUnavailableError

  @type t :: Module

  @type ok :: {:ok, true}

  @type error ::
          {
            :error,
            struct()
            | ServiceUnavailableError.t()
          }

  @callback send_mail(binary(), binary(), binary(), binary()) :: ok() | error()
end
