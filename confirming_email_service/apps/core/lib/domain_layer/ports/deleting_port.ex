defmodule Core.DomainLayer.Ports.DeletingPort do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Email

  alias Core.DomainLayer.Dtos.ImpossibleDeleteError

  alias Core.DomainLayer.Dtos.NotFoundError

  @type ok :: {:ok, true}

  @type error :: {
          :error,
          ImpossibleDeleteError.t()
          | NotFoundError.t()
        }

  @callback delete(Email.t()) :: ok() | error()
end
