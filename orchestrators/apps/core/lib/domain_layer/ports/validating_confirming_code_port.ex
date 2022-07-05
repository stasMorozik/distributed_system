defmodule Core.DomainLayer.Ports.ValidatingConfirmingCodePort do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ImpossibleDeleteError
  alias Core.DomainLayer.Dtos.NotFoundError
  alias Core.DomainLayer.Dtos.ImpossibleGetError
  alias Core.DomainLayer.Dtos.CodeIsWrongError
  alias Core.DomainLayer.Dtos.CodeIsInvalidError
  alias Core.DomainLayer.Dtos.ImpossibleValidateError
  alias Core.DomainLayer.Dtos.ServiceUnavailableError

  @type t :: Module

  @type ok :: {:ok, true}

  @type error :: {
          :error,
          NotFoundError.t()
          | ImpossibleDeleteError.t()
          | ImpossibleGetError.t()
          | CodeIsWrongError.t()
          | CodeIsInvalidError.t()
          | ImpossibleValidateError.t()
          | ServiceUnavailableError.t()
        }


  @callback validate(binary(), integer()) :: ok() | error()
end
