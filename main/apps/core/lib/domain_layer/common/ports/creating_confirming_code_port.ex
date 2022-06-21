defmodule Core.DomainLayer.Common.Ports.CreatingConfirmingCodePort do
  @moduledoc false

  alias Core.DomainLayer.Common.Dtos.ImpossibleCreateError
  alias Core.DomainLayer.Common.Dtos.ImpossibleCallError
  alias Core.DomainLayer.Common.Dtos.IdIsInvalidError
  alias Core.DomainLayer.Common.ValueObjects.ConfirmingCode

  @type t :: Module

  @type ok :: {:ok, ConfirmingCode.t()}

  @type error :: {
          :error,
          ImpossibleCreateError .t()
          | ImpossibleCallError.t()
          | IdIsInvalidError.t()
          | ImpossibleCreateError.t()
        }

  @callback create(ConfirmingCode.t())
end
