defmodule Core.DomainLayer.Ports.NotifyingMailPort do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ServiceUnavailableError
  alias Core.DomainLayer.Dtos.ImpossibleCreateError
  alias Core.DomainLayer.Dtos.MessageIsInvalidError
  alias Core.DomainLayer.Dtos.MessageIsTooLongError
  alias Core.DomainLayer.Dtos.EmailIsInvalidError
  alias Core.DomainLayer.Dtos.SubjectIsInvalidError
  alias Core.DomainLayer.Dtos.SubjectIsTooLongError
  alias Core.DomainLayer.Dtos.ServiceUnavailableError

  @type t :: Module

  @type ok :: {:ok, true}

  @type error ::
          {
            :error,
            ImpossibleCreateError.t()
            | MessageIsTooLongError.t()
            | EmailIsInvalidError.t()
            | MessageIsInvalidError.t()
            | SubjectIsTooLongError.t()
            | SubjectIsInvalidError.t()
            | ServiceUnavailableError.t()
            | ServiceUnavailableError.t()
          }

  @callback send_mail(binary(), binary(), binary(), binary()) :: ok() | error()
end
