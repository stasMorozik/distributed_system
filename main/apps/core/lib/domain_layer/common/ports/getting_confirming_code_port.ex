defmodule Core.DomainLayer.Common.Ports.GettingConfirmingCodePort do
  @moduledoc false

  alias Core.DomainLayer.Common.Dtos.NotFoundError
  alias Core.DomainLayer.Common.Dtos.ImpossibleGetError
  alias Core.DomainLayer.Common.Dtos.ImpossibleCallError
  alias Core.DomainLayer.Common.ValueObjects.ConfirmingCode

  @type t :: Module

  @type ok :: {:ok, ConfirmingCode.t()}

  @type error :: {
          :error,
          NotFoundError.t()
          | ImpossibleGetError.t()
          | ImpossibleCallError.t()
        }

  @callback get(binary()) :: ok() | error()
end
