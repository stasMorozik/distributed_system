defmodule Core.DomainLayer.Ports.GettingPort do
  @moduledoc false

  alias Core.DomainLayer.ConfirmingCodeEntity

  alias Core.DomainLayer.Dtos.ImpossibleGetError

  alias Core.DomainLayer.ValueObjects.Email

  alias Core.DomainLayer.Dtos.NotFoundError

  @type ok :: {
          :ok,
          ConfirmingCodeEntity.t()
        }

  @type error :: {
          :error,
          NotFoundError.t()
          | ImpossibleGetError.t()
        }

  @callback get(Email.t()) :: ok() | error()
end
