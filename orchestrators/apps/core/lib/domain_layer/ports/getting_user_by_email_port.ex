defmodule Core.DomainLayer.Ports.GettingUserByEmailPort do
  @moduledoc false

  alias Core.DomainLayer.Dtos.NotFoundError
  alias Core.DomainLayer.Dtos.EmailIsInvalidError
  alias Core.DomainLayer.Dtos.ImpossibleGetError
  alias Core.DomainLayer.Dtos.PasswordIsNotTrueError
  alias Core.DomainLayer.Dtos.PasswordIsInvalidError
  alias Core.DomainLayer.Dtos.ImpossibleValidatePasswordError
  alias Core.DomainLayer.Dtos.ServiceUnavailableError

  alias Core.DomainLayer.UserEntity

  @type t :: Module

  @type ok :: {
          :ok,
          UserEntity.t()
        }

  @type error :: {
          :errror,
          NotFoundError.t()
          | EmailIsInvalidError.t()
          | ImpossibleGetError.t()
          | ServiceUnavailableError.t()
          | PasswordIsNotTrueError.t()
          | PasswordIsInvalidError.t()
          | ImpossibleValidatePasswordError.t()
        }

  @callback get(binary(), binary()) :: ok() | error()
end
