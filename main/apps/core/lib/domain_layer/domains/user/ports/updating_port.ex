defmodule Core.DomainLayer.Domains.User.Ports.UpdatingPort do
  @moduledoc false

  alias Core.DomainLayer.Common.Dtos.ImpossibleUpdateError
  alias Core.DomainLayer.Common.Dtos.IdIsInvalidError
  alias Core.DomainLayer.Common.Dtos.ImpossibleCallError
  alias Core.DomainLayer.Common.Dtos.AlreadyExistsError
  alias Core.DomainLayer.Domains.User.UserEntity

  @type t :: Module

  @type ok :: {:ok, UserEntity.t()}

  @type error :: {
          :error,
          ImpossibleUpdateError.t()
          | IdIsInvalidError.t()
          | ImpossibleCallError.t()
          | AlreadyExistsError.t()
        }

  @callback create(UserEntity.t()) :: ok() | error()
end
