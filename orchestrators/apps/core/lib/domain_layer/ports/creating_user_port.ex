defmodule Core.DomainLayer.Ports.CreatingUserPort do
  @moduledoc false

  @type t :: Module

  alias Core.DomainLayer.Dtos.AlreadyExistsError
  alias Core.DomainLayer.Dtos.ImpossibleCreateError
  alias Core.DomainLayer.Dtos.NameIsInvalidError
  alias Core.DomainLayer.Dtos.SurnameIsInvalidError
  alias Core.DomainLayer.Dtos.EmailIsInvalidError
  alias Core.DomainLayer.Dtos.PhoneNumberIsInvalidError
  alias Core.DomainLayer.Dtos.PasswordIsInvalidError
  alias Core.DomainLayer.Dtos.ImageIsInvalidError
  alias Core.DomainLayer.Dtos.ServiceUnavailableError

  @type ok :: {:ok, true}

  @type error :: {
          :error,
          AlreadyExistsError.t()
          | ImpossibleCreateError.t()
          | NameIsInvalidError.t()
          | SurnameIsInvalidError.t()
          | EmailIsInvalidError.t()
          | PhoneNumberIsInvalidError.t()
          | PasswordIsInvalidError.t()
          | ImageIsInvalidError.t()
          | ServiceUnavailableError.t()
        }

  @type creating_dto ::
        %{
          name: binary(),
          surname: binary(),
          email: binary(),
          phone: binary(),
          password: binary(),
          avatar: binary()
        }

  @callback create(creating_dto()) :: ok() | error()
end
