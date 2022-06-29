defmodule Core.DomainLayer.Domains.User.Ports.CreatingPort do
  @moduledoc false

  alias Core.DomainLayer.Common.Dtos.ImpossibleCreateError
  alias Core.DomainLayer.Common.Dtos.IdIsInvalidError
  alias Core.DomainLayer.Common.Dtos.ImpossibleCallError
  alias Core.DomainLayer.Common.Dtos.AlreadyExistsError

  @type t :: Module

  @type ok :: {:ok, true}

  @type error :: {
          :error,
          ImpossibleCreateError.t()
          | IdIsInvalidError.t()
          | ImpossibleCallError.t()
          | AlreadyExistsError.t()
        }

  @callback create(UserEntity.t()) :: ok() | error()
end
