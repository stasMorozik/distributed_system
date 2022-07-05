defmodule Core.DomainLayer.Ports.CreatingConfirmingCodePort do
  @moduledoc false

  alias Core.DomainLayer.ConfirmingCodeEntity

  alias Core.DomainLayer.Dtos.ImpossibleUpdateError
  alias Core.DomainLayer.Dtos.ImpossibleCreateError
  alias Core.DomainLayer.Dtos.IdIsInvalidError
  alias Core.DomainLayer.Dtos.EmailIsInvalidError
  alias Core.DomainLayer.Dtos.AlreadyExistsError
  alias Core.DomainLayer.Dtos.ServiceUnavailableError

  @type t :: Module

  @type ok :: {
          :ok,
          ConfirmingCodeEntity.t()
        }

  @type error :: {
          :error,
          ImpossibleUpdateError.t()
          | ImpossibleCreateError.t()
          | IdIsInvalidError.t()
          | EmailIsInvalidError.t()
          | AlreadyExistsError.t()
          | ServiceUnavailableError.t()
        }

  @callback create(binary()) :: ok() | error()
end
