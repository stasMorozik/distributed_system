defmodule Core.CoreDomains.Domains.Password.Ports.ConfirmingPort do
  alias Core.CoreDomains.Domains.Password

  alias Core.CoreDomains.Domains.Password.Dtos.NotFoundError
  alias Core.CoreDomains.Domains.Password.Dtos.AlreadyConfirmedError
  alias Core.CoreDomains.Domains.Password.Dtos.ImpossibleConfirmError
  alias Core.CoreDomains.Common.Dtos.IdIsInvalidError

  @type t :: module

  @type error :: {:error, NotFoundError.t() | AlreadyConfirmedError.t() | ImpossibleConfirmError.t() | IdIsInvalidError.t()}

  @type ok :: {:ok, Password.t()}

  @callback confirm(Password.t()) :: ok | error
end
