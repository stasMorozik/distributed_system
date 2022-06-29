defmodule Core.DomainLayer.Domains.User.Ports.GettingByEmailPort do
  @moduledoc false

  alias Core.DomainLayer.Common.Dtos.EmailIsInvalidError
  alias Core.DomainLayer.Common.Dtos.NotFoundError
  alias Core.DomainLayer.Common.Dtos.ImpossibleGetError
  alias Core.DomainLayer.Common.Dtos.ImpossibleCallError
  alias Core.DomainLayer.Domains.User.UserEntity

  alias Core.DomainLayer.Common.ValueObjects.Email

  @type t :: Module

  @type ok :: {:ok, UserEntity.t()}

  @type error :: {
        :error,
        EmailIsInvalidError.t()
        | NotFoundError.t()
        | ImpossibleGetError.t()
        | ImpossibleCallError.t()
      }

  @callback get(Email.t()) :: ok() | error()
end
