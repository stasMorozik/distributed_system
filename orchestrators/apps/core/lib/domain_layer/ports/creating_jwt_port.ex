defmodule Core.DomainLayer.Ports.CreatingJwtPort do
  @moduledoc false

  alias Core.DomainLayer.Dtos.EmailIsInvalidError
  alias Core.DomainLayer.Dtos.SecretIsInvalidError
  alias Core.DomainLayer.Dtos.ExpiredIsInvalidError
  alias Core.DomainLayer.Dtos.ImpossibleCreateError
  alias Core.DomainLayer.Dtos.JokenError
  alias Core.DomainLayer.Dtos.ServiceUnavailableError

  alias Core.DomainLayer.JWTEntity

  @type t :: Module

  @type ok :: {:ok, JWTEntity.t()}

  @type error :: {
          :error,
          EmailIsInvalidError.t()
          | SecretIsInvalidError.t()
          | ExpiredIsInvalidError.t()
          | ImpossibleCreateError.t()
          | JokenError.t()
          | ServiceUnavailableError.t()
        }

  @callback create(binary(), binary()) :: ok() | error()
end
